pipeline { 
    agent any
    environment{
        PATH = "/opt/maven/apache-maven-3.9.0/bin:$PATH"
    }
    stages {
        stage("SCM Checkout"){
            steps{
                git credentialsId: 'git_credentials', url: 'https://github.com/swetha2310/hello-world.git', branch:'master'
            }
        }
        stage('Code Quality Analysis'){
//    def scannerHome = tool 'SonarScanner 4.0';
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
        stage('Docker Build'){
            steps{
                sh "docker build . -t swetha23/helloworldmaven_0.1"
            }
        }
        stage('Push to dockerHub'){
            steps{
                withCredentials([string(credentialsId: 'swetha23', variable: 'dockerpassword')]) {
                sh "docker login -u swetha23 -p ${dockerpassword}"
                }
                sh "docker push swetha23/helloworldmaven_0.1"
            }
        }
        stage('Deploy to EKS'){
            steps{
                withKubeConfig(caCertificate: '', clusterName: '', contextName: '', credentialsId: 'EKS', namespace: '', restrictKubeConfigAccess: false, serverUrl: '') {
                //sh "kubectl apply -f eksdep-K8s.yaml"//
                sh " kubectl delete deployment my-app "
                sh " kubectl apply -f eksdep-K8s.yaml "
                }
            }
        }
    }
}
