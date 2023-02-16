pipeline { 
    agent any
    environment{
        PATH = "/opt/maven/apache-maven-3.9.0/bin:$PATH"
    }
    stages {
        stage("SCM Checkout") {
            steps{
                git credentialsId: 'git_credentials', url: 'https://github.com/swetha2310/hello-world.git', branch:'master'
            }
        }
        stage('Code Quality Analysis') {
            steps{
              withSonarQubeEnv('sonarqube-8.9.2') { 
        // If you have configured more than one global server connection, you can specify its name
//           sh "${scannerHome}/bin/sonar-scanner"
             sh "mvn sonar:sonar"
              }
            }
        }
        stage("Maven Build"){
            steps{
                sh "mvn clean install"
            }
        }
        stage("Nexus Artifact"){
            steps{
                nexusArtifactUploader artifacts: [
                    [
                    artifactId: 'maven-project', 
                    classifier: '', 
                    file: '/var/lib/jenkins/workspace/Nexus-Job/webapp/target/webapp.war', 
                    type: 'war'
                    ]
                ], 
                credentialsId: 'nexus', 
                groupId: 'com.example.maven-project', 
                nexusUrl: '65.2.186.137:8081/', 
                nexusVersion: 'nexus3', 
                protocol: 'http', 
                repository: 'maven-releases', 
                version: '1.0.0'
           }
        }
        stage("Deploy war using Ansible"){
            steps{
                /*sh "pwd"
                #sh "cd /usr/bin/ansible-ws"
                #sh "rm -rf hello-world"
                sh "git clone https://github.com/swetha2310/hello-world.git" */
                sh "ls -ltrh"
                ansiblePlaybook credentialsId: 'private-key', disableHostKeyChecking: true, installation: 'ansible', inventory: './dev.inv', playbook: './copyfile.yml'
            }
        }
        stage('Dependency Check'){
            steps {
                dependencyCheck additionalArguments: '--format HTML', odcInstallation: 'DP-check'
            }
        }
        stage('OWASP DAST'){
            steps {
                sh '''
                docker pull owasp/zap2docker-stable
                docker run -dt --name owasp owasp/zap2docker-stable sh
                docker exec owasp mkdir /zap/wrk
                docker exec owasp zap-baseline.py -t http://35.154.101.50:8080/webapp/ -x report.xml -I
                echo $WORKSPACE
                docker cp owasp:/zap/wrk/report.xml $WORKSPACE/report.xml
                docker stop owasp && docker rm owasp
                 '''
            }
        }
        /*stage("Deploy code"){
            steps{
                sshagent(['deploy_user']) {
                    sh "scp -o StrictHostKeyChecking=no webapp/target/webapp.war ec2-user@172.31.15.59:/opt/apache-tomcat-8.5.85/webapps"
                    
                }
            }
        }*/
    }
}
