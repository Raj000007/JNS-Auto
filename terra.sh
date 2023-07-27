#!/bin/bash

# Function to execute Terraform commands in a directory
execute_terraform() {
  directory=$1
  echo "Executing Terraform commands in $directory"
  cd "$directory" || exit
  # Replace with your desired Terraform commands (e.g., init, plan, apply, etc.)
  terraform init
  terraform plan
  terraform apply -auto-approve
  # Add more Terraform commands as needed
}

# List of directories where you want to execute Terraform commands
directories=(
  "/c/Users/User/Desktop/skillrary/Terraform-Jenkins-nexus-sonarqube/jenkins" #Replace the path
  "/c/Users/User/Desktop/skillrary/Terraform-Jenkins-nexus-sonarqube/nexus" #Replace the path
  "/c/Users/User/Desktop/skillrary/Terraform-Jenkins-nexus-sonarqube/sonarqube" #Replace the path
  # Add more directories as needed
)

# Loop through the directories and execute Terraform commands in each of them
for directory in "${directories[@]}"; do
  if [ -d "$directory" ]; then
    execute_terraform "$directory"
  else
    echo "Directory $directory does not exist."
  fi
done
