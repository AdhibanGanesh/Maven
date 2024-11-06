#!/bin/bash

# Check if the script is run with superuser privileges
if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root"
  exit 1
fi

# Update the package index
apt update

# Install Git
apt install git -y

# Install OpenJDK 17 (Jenkins dependency)
apt install fontconfig openjdk-17-jdk openjdk-17-jre -y

# Set JAVA_HOME globally
echo "JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64" >>/etc/environment
echo "PATH=\$PATH:/usr/lib/jvm/java-17-openjdk-amd64/bin" >>/etc/environment
source /etc/environment

# Verify Java installation
java -version

# Install Maven
apt install maven -y
mvn -version

# Add Jenkins GPG key and repository, and install Jenkins
wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | tee /etc/apt/sources.list.d/jenkins.list >/dev/null
apt update
apt install jenkins -y

# Start Jenkins service and enable it to run on boot
systemctl start jenkins
systemctl enable jenkins

# Add Docker's official GPG key and repository
apt install -y ca-certificates curl
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list >/dev/null
apt update

# Install Docker and its related plugins
apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Start Docker service and run test container
systemctl start docker
docker run hello-world

# Add Jenkins user to the Docker group to allow Jenkins access to Docker
usermod -aG docker jenkins
systemctl restart jenkins

# Install Ngrok
curl -sSL https://ngrok-agent.s3.amazonaws.com/ngrok.asc | tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null
echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | tee /etc/apt/sources.list.d/ngrok.list
apt update
apt install ngrok -y
ngrok version

# Set the LANG variable in /etc/default/locale
if grep -q "^LANG=" /etc/default/locale; then
  sed -i 's/^LANG=.*/LANG="en_IN.UTF-8"/' /etc/default/locale
else
  echo 'LANG="en_IN.UTF-8"' >>/etc/default/locale
fi
source /etc/default/locale

# Inform the user to log out and back in for locale changes to take effect
echo "Installation completed. Please log out and back in for the changes to take effect."
