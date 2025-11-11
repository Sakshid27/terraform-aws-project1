pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID = credentials('aws-creds')
        AWS_SECRET_ACCESS_KEY = credentials('aws-creds')
    }

    stages {
        stage('Checkout Code') {
            steps {
                git 'https://github.com/Sakshid27/terraform-aws-project1.git'
            }
        }

        stage('Initialize Terraform') {
            steps {
                bat 'terraform init'
            }
        }

        stage('Plan Infrastructure') {
            steps {
                bat 'terraform plan -out=tfplan'
            }
        }

        stage('Apply Infrastructure') {
            steps {
                input message: 'Approve deployment to AWS?'
                bat 'terraform apply -auto-approve tfplan'
            }
        }

        stage('Destroy Infrastructure') {
            steps {
                input message: 'Approve destroy?'
                bat 'terraform destroy -auto-approve'
            }
        }
    }

    post {
        always {
            echo 'Pipeline execution completed successfully.'
        }
    }
}
