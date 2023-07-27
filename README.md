Step 1:
--------
Write the Terraform script to create the Nexus server

Step 2:
--------
Clone the repository Get inside the nexus Directory and alter the AWS access_key, Secret_key, ami-ID, region, and keypair in nexus.tf file Alter the VPC id in nexus_sg.tf file

Step 3:
-------
Now execute the terraform lifecycle commands as follows:

1. Terraform init
2. Terraform fmt
3. Terraform validate
4. Terraform plan
5. Terraform apply
Once executing all the commands infrastructure will be created in the AWS account

Step 4:
--------
Write a terraform script to create the Jenkins server, For that get inside the Jenkins directory and alter the AWS access_key, Secret_key, ami-ID, region, and keypair in jenkins.tf file Alter the VPC id in jenkins_sg.tf file

Step 5:
--------
Now execute the terraform lifecycle commands as follows:


1. Terraform init
2. Terraform fmt
3. Terraform validate
4. Terraform plan
5. Terraform apply

Step 6:
--------
Write a terraform script to create the SonarQube server, For that get inside the sonarqube directory and alter the AWS access_key, Secret_key, ami-ID, region, and keypair in sonarqube.tf file Alter the VPC id in sonarqube_sg.tf file

Step 7:
--------
Now execute the terraform lifecycle commands as follows:


1. Terraform init
2. Terraform fmt
3. Terraform validate
4. Terraform plan
5. Terraform apply

Note:
-----
Make sure that your ami-ID, Keypair, and VPC id belong to the same region

Now the infrastructure is created and now follow the further steps as mentioned below:

**Note**

Instead of doing all these 7 steps, there is a shell script in this repository with the name **terr.sh** just open that file and alter the path of the Jenkins, nexus,and sonarqube path run **"sh terra.sh"**

Accessing the server using the publicip and port number
----------------------------------------------
Access Jenkins server with the public_ip and port number 8080
Access SonarQube server with the public_ip and port number 9000
Access to Nexus server with the public_ip and port number 8081

Step 1:
-------
 Connect to nexus  create the repository as below:
 
1.maven2 hosted
   Name: Release
   Version policy: Release

2.maven2 proxy 
  Name: central
  remote storage: https://repo1.maven.org/maven2/

3.maven2 hosted
  Name: snapshot
  Version policy: Snapshot

4. Repository type: maven2 group
   Name: group
   Member repositories: 
   - central
   - release
   - snapshot

 Step 2:
-------
 
Connect to the sonar qube server 

1. Generate the tokens
    My account -> security 
    Enter the token name 
    copy the token the token looks as below 
    (451261c001813ac2cf0b7774d67fd5baa5c99dec)

2, Create the project in the sonar qube :
    Projects -> Create new project 
    Project key: JNS
    Project name: JNS 
    Provide token
    Use existing token: add the token that you generated
    Project Language: JAVA
    Build Technology: Maven
     
Step 3:
------

Connect to jenkins server and do the configuration as below:

1. Configure the java 
    Manage Jenkins -> Global Tool Configuration -> add jdk 
    Name: JAVA_HOME
    Uncheck install automatically
    path: /usr/lib/jvm/java-8-openjdk-amd64

2. Configure the Maven 
    Manage Jenkins -> Global Tool Configuration -> add maven
    Name: MAVEN_HOME
    Install automatically 

3. Add the nexus and SonarQube credentials in Jenkins
   Manage Jenkins -> Credentials -> system -> global credentials -> Add credentials 
   Kind: Username and password(Nexus)
   enter the username of nexus (admin)
   enter the password of nexus (admin)
   id: nexus
   discription: nexus
   
   Kind: Secret text
   secret: enter the token that yuou have generated in Sonarqube 
   id:sonar
   discription:sonar
   
4. Downloading and Installing Plugins in Jenkins
   Manage Jenkins -> Plugins -> Available Plugins
   Download the plugins called "SonarQube Scanner" ," Nexus Artifact Uploader" , "Nexus Platform Plugin"

4. Configure the SonarQube in Jenkins
    Manage Jenkins -> Global Tool Configuration
    Add sonar scanner
    name: sonarscanner
    tick install automatically
    Manage Jenkins -> System
    tick environment variables
    Add sonarqube 
    Name: sonarserver
    Server URL: http://<private_ip_of_sonar_server> 
    Server authentication token: we need to create token from sonar website
      
5. Create a pipeline Job with below copnfigurations
    Go to pipeline choose pipeline script form SCM
    SCM : Git
    Repository URL : Enter the github repository URL
    Script path: Jenkinsfile
    post build 
    - Choose slack Notification 

Note: 
-----
If it is a private repository add the credentials by clicking on add -> jenkins -> Kind as Username and password -> Username : Github gmail -> Password: Github password
-> Name: git -> discription: git


6. Configure jenkins and slack
    - Login to slack and create a workspace by following the prompts. Then create a channel "jenkins-cicd" in our workspace.
    - Next we need to Add jenkins app to slack. Search in Google with Slack apps. Then search for jenkins add to Slack. 
       We will choose the channel jenkins-cicd. It will give us to setup instructions,  as follws and It will give us to setup instructions, from there copy Integration token credential ID .
       1. In your Jenkins dashboard, click on Manage Jenkins from the left navigation.
       2. Click on Manage Plugins and search for Slack Notification in the Available tab. Click the checkbox and install the plugin.
       3. After it's installed, click on Manage Jenkins again in the left navigation, and then go to Configure System. Find the Global Slack Notifier Settings section and add the following values:
          Team Subdomain: jenkins-cicdco
          Integration Token Credential ID: Create a secret text credential using RfzAY87BFjlYZ4npY7QI95Dg as the value
          The other fields are optional. You can click on the question mark icons next to them for more information. Press Save when you're done. 

Note:
 Please remember to replace the Integration Token
