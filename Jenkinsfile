pipeline {
    agent any

    stages {
        stage('git-clone') {
            steps {
               checkout scmGit(branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[credentialsId: '6d3092bb-4e3b-49a2-be7d-c4c5c5075a38', url: 'https://github.com/wahtej/php.git']]) 
            }
        }
        stage('terraform initiate') {
            steps {
                sh 'terraform init'
                
            }
        }
        stage('terraform apply') {
            steps {
                sh 'terraform apply -var-file=dev.tfvars -auto-approve'
                
            }
        }
    }
}
