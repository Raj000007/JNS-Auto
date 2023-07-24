#!/bin/bash

# Update system and install OpenJDK 11
sudo apt update
sudo apt install -y openjdk-11-jdk

# Adjust system limits
sudo sysctl -w vm.max_map_count=262144
sudo sysctl -w fs.file-max=131072
ulimit -n 131072
ulimit -u 8192



# Wait for the system to reboot and proceed to the next commands

# Create sonarh2s user
sudo adduser --system --no-create-home --group --disabled-login sonarh2s

# Install PostgreSQL 13
wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O- | sudo apt-key add -
echo "deb [arch=amd64] http://apt.postgresql.org/pub/repos/apt/ focal-pgdg main" | sudo tee /etc/apt/sources.list.d/postgresql.list
sudo apt update
sudo apt install -y postgresql-13


# Set password for postgres user
sudo echo "postgres:admin" | sudo chpasswd
sudo -u postgres createuser sonaruser
sudo -u postgres psql -c "ALTER USER sonaruser WITH ENCRYPTED PASSWORD 'admin';"
sudo -u postgres psql -c "CREATE DATABASE sonardb OWNER sonaruser;"

# Download and install SonarQube
wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-8.9.10.61524.zip
sudo apt -y install unzip
sudo unzip sonarqube-*.zip -d /opt
sudo mv /opt/sonarqube-* /opt/sonarqube
sudo chown -R sonarh2s:sonarh2s /opt/sonarqube

# Configure SonarQube properties
sudo tee /opt/sonarqube/conf/sonar.properties <<EOF
sonar.jdbc.username=sonaruser
sonar.jdbc.password=admin
sonar.jdbc.url=jdbc:postgresql://localhost/sonardb
sonar.web.javaAdditionalOpts=-server
sonar.java.binaries=target/classes
EOF

# Create SonarQube service file
sudo tee /etc/systemd/system/sonar.service <<EOF
[Unit]
Description=SonarQube service
After=syslog.target network.target

[Service]
Type=forking
ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop
LimitNOFILE=65536
LimitNPROC=4096
User=sonarh2s
Group=sonarh2s
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd configuration and start SonarQube service
sudo systemctl daemon-reload
sudo systemctl enable sonar
sudo systemctl start sonar


# Check SonarQube status as sonarh2s user
sudo -Hu sonarh2s /opt/sonarqube/bin/linux-x86-64/sonar.sh start
sudo -Hu sonarh2s /opt/sonarqube/bin/linux-x86-64/sonar.sh console
