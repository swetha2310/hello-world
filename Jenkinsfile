pipeline { 
    agent any
    environment{
        PATH = "/opt/maven/apache-maven-3.9.0/bin:$PATH"
    }
    stages {
        stage('git') {
            steps {
                git branch: 'master', url: 'https://github.com/swetha2310/hello-world.git'
            }
        }
        stage('SonarQube analysis') {
//    def scannerHome = tool 'SonarScanner 4.0';
            steps{
                withSonarQubeEnv('sonarqube-8.9.2') { 
                // If you have configured more than one global server connection, you can specify its name
//              sh "${scannerHome}/bin/sonar-scanner"
                sh "mvn sonar:sonar"
                sh "cat target/sonar/report-task.txt"
                }
            }
       }
        stage('Build'){
            steps{
                sh 'mvn clean package'
            }
         }
        /*stage('Dependency Check') {
            steps {
                dependencyCheck additionalArguments: '--format HTML', odcInstallation: 'DP-check'
            }
        }*/
        stage('Docker Build'){
            steps{
                sh "docker build . -t swetha23/helloworldmaven_0.1:$BUILD_NUMBER"
            }
        }
        stage('Push to dockerHub'){
            steps{
                withCredentials([string(credentialsId: 'swetha23', variable: 'dockerpassword')]) {
                sh "docker login -u swetha23 -p ${dockerpassword}"
                }
                sh "docker push swetha23/helloworldmaven_0.1:$BUILD_NUMBER"
            }
        }
        stage('Deploy to EKS'){
            steps{
                withKubeConfig(caCertificate: '', clusterName: '', contextName: '', credentialsId: 'EKS', namespace: '', restrictKubeConfigAccess: false, serverUrl: '') {
                sh 'chmod +x changeTag.sh'
		sh './changeTag.sh $BUILD_NUMBER'
                //sh "kubectl apply -f eksdep-K8s.yaml"//
                //sh " kubectl delete deployment my-app "//
                sh " kubectl apply -f rollingupdate.yml "
                }
            }
        }
        stage('OWASP DAST') {
            steps {
                sh '''
                docker pull owasp/zap2docker-stable
                docker run -dt --name owasp owasp/zap2docker-stable sh
                docker exec owasp mkdir /zap/wrk
                docker exec owasp zap-baseline.py -t http://13.126.94.153:8080/webapp/ -x report.xml -I
                echo $WORKSPACE
                docker cp owasp:/zap/wrk/report.xml $WORKSPACE/report.xml
                docker stop owasp && docker rm owasp
                 '''
            }
        }
    }
}
