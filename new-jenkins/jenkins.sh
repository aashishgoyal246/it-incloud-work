#!/bin/bash

# Make sure that port 8080 is added to the firewall or in the aws security group

apt-get update

apt-get install -y unzip
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install

# Installing java for jenkins

apt-get install -y openjdk-8-jdk

# Installing jenkins on the aws ec2 server

wget -q -O - https://pkg.jenkins.io/debian/jenkins-ci.org.key | apt-key add -
echo deb https://pkg.jenkins.io/debian-stable binary/ | tee /etc/apt/sources.list.d/jenkins.list
apt-get update
apt-get install -y jenkins

ip=$(curl icanhazip.com)
wget http://$ip:8080/jnlpJars/jenkins-cli.jar
sed -i 's/JAVA_ARGS="-Djava.awt.headless=true"/JAVA_ARGS="-Djenkins.install.runSetupWizard=false"/g' /etc/default/jenkins
mkdir /var/lib/jenkins/init.groovy.d/
touch /var/lib/jenkins/init.groovy.d/basic-security.groovy
cat >> /var/lib/jenkins/init.groovy.d/basic-security.groovy <<EOF
#!groovy
import jenkins.model.*
import hudson.util.*;
import jenkins.install.*;
def instance = Jenkins.getInstance()
instance.setInstallState(InstallState.INITIAL_SETUP_COMPLETED)
EOF

systemctl restart jenkins

sleep 3

ip_1=$(curl icanhazip.com)

sleep 5

pass=`cat /var/lib/jenkins/secrets/initialAdminPassword` && echo 'jenkins.model.Jenkins.instance.securityRealm.createAccount("it_incloud", "it_incloud")' | java -jar ./jenkins-cli.jar -auth admin:$pass -s http://$ip_1:8080/ groovy =

echo 'jenkins.model.Jenkins.instance.securityRealm.createAccount("a_goyal", "a_goyal")' | java -jar ./jenkins-cli.jar -s http://$ip_1:8080/ -auth it_incloud:it_incloud -noKeyAuth groovy = –

echo 'jenkins.model.Jenkins.instance.securityRealm.createAccount("a_bishnoi", "a_bishnoi")' | java -jar ./jenkins-cli.jar -s http://$ip_1:8080/ -auth it_incloud:it_incloud -noKeyAuth groovy = –

echo 'jenkins.model.Jenkins.instance.securityRealm.createAccount("a_satya", "a_satya")' | java -jar ./jenkins-cli.jar -s http://$ip_1:8080/ -auth it_incloud:it_incloud -noKeyAuth groovy = –

echo 'jenkins.model.Jenkins.instance.securityRealm.createAccount("a_raghu", "a_raghu")' | java -jar ./jenkins-cli.jar -s http://$ip_1:8080/ -auth it_incloud:it_incloud -noKeyAuth groovy = –

echo 'jenkins.model.Jenkins.instance.securityRealm.createAccount("a_developer", "a_developer")' | java -jar ./jenkins-cli.jar -s http://$ip_1:8080/ -auth it_incloud:it_incloud -noKeyAuth groovy = –

java -jar ./jenkins-cli.jar -s http://$ip_1:8080/ -auth it_incloud:it_incloud -noKeyAuth install-plugin terraform

java -jar ./jenkins-cli.jar -s http://$ip_1:8080/ -auth it_incloud:it_incloud -noKeyAuth install-plugin github

java -jar ./jenkins-cli.jar -s http://$ip_1:8080/ -auth it_incloud:it_incloud -noKeyAuth install-plugin simple-build-for-pipeline

java -jar ./jenkins-cli.jar -s http://$ip_1:8080/ -auth it_incloud:it_incloud -noKeyAuth install-plugin global-slack-notifier

java -jar ./jenkins-cli.jar -s http://$ip_1:8080/ -auth it_incloud:it_incloud -noKeyAuth install-plugin aws-global-configuration

java -jar ./jenkins-cli.jar -s http://$ip_1:8080/ -auth it_incloud:it_incloud -noKeyAuth install-plugin ws-cleanup

java -jar ./jenkins-cli.jar -s http://$ip_1:8080/ -auth it_incloud:it_incloud -noKeyAuth install-plugin s3

java -jar ./jenkins-cli.jar -s http://$ip_1:8080/ -auth it_incloud:it_incloud -noKeyAuth install-plugin thinBackup

java -jar ./jenkins-cli.jar -s http://$ip_1:8080/ -auth it_incloud:it_incloud -noKeyAuth install-plugin kubernetes

java -jar ./jenkins-cli.jar -s http://$ip_1:8080/ -auth it_incloud:it_incloud -noKeyAuth install-plugin slack -restart

sleep 45

ip_2=$(curl icanhazip.com)

touch credentials.xml job.xml

cat > credentials.xml <<EOF
<org.jenkinsci.plugins.plaincredentials.impl.StringCredentialsImpl plugin="plain-credentials@1.7">
          <scope>GLOBAL</scope>
          <id>Slack</id>
          <description>Slack</description>
          <secret>f96LTlowlBMWJLa5UR5Xylsh</secret>
</org.jenkinsci.plugins.plaincredentials.impl.StringCredentialsImpl>
EOF

sleep 3

java -jar ./jenkins-cli.jar -s http://$ip_2:8080/ -auth it_incloud:it_incloud create-credentials-by-xml system::system::jenkins _ < credentials.xml

cat > job.xml <<EOF
<?xml version='1.1' encoding='UTF-8'?>
<project>
  <description></description>
  <keepDependencies>false</keepDependencies>
  <properties/>
  <scm class="hudson.scm.NullSCM"/>
  <assignedNode>kubepods</assignedNode>
  <canRoam>false</canRoam>
  <disabled>false</disabled>
  <blockBuildWhenDownstreamBuilding>false</blockBuildWhenDownstreamBuilding>
  <blockBuildWhenUpstreamBuilding>false</blockBuildWhenUpstreamBuilding>
  <triggers/>
  <concurrentBuild>false</concurrentBuild>
  <builders>
    <hudson.tasks.Shell>
      <command>hostname</command>
    </hudson.tasks.Shell>
  </builders>
  <publishers>
    <jenkins.plugins.slack.SlackNotifier plugin="slack@2.37">
      <baseUrl></baseUrl>
      <teamDomain></teamDomain>
      <authToken></authToken>
      <tokenCredentialId></tokenCredentialId>
      <botUser>false</botUser>
      <room></room>
      <sendAsText>false</sendAsText>
      <iconEmoji></iconEmoji>
      <username></username>
      <startNotification>true</startNotification>
      <notifySuccess>true</notifySuccess>
      <notifyAborted>true</notifyAborted>
      <notifyNotBuilt>true</notifyNotBuilt>
      <notifyUnstable>true</notifyUnstable>
      <notifyRegression>true</notifyRegression>
      <notifyFailure>false</notifyFailure>
      <notifyEveryFailure>true</notifyEveryFailure>
      <notifyBackToNormal>true</notifyBackToNormal>
      <notifyRepeatedFailure>false</notifyRepeatedFailure>
      <includeTestSummary>false</includeTestSummary>
      <includeFailedTests>false</includeFailedTests>
      <commitInfoChoice>NONE</commitInfoChoice>
      <includeCustomMessage>false</includeCustomMessage>
      <customMessage></customMessage>
      <customMessageSuccess></customMessageSuccess>
      <customMessageAborted></customMessageAborted>
      <customMessageNotBuilt></customMessageNotBuilt>
      <customMessageUnstable></customMessageUnstable>
      <customMessageFailure></customMessageFailure>
    </jenkins.plugins.slack.SlackNotifier>
  </publishers>
  <buildWrappers/>
</project>
EOF

sleep 3

java -jar ./jenkins-cli.jar -s http://$ip_2:8080/ -auth it_incloud:it_incloud create-job demo < job.xml

aws s3 cp s3://awsitops-bucket/ip.txt .
cat ip.txt