pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws-creds')
        AWS_SECRET_ACCESS_KEY = credentials('aws-creds')
    }

    stages {
        stage('Checkout Code') {
            steps {
                echo 'Fetching latest code from GitHub...'
                checkout scm
            }
        }

        stage('Initialize Terraform') {
            steps {
                echo 'Initializing Terraform...'
                bat 'terraform init'
            }
        }

        stage('Plan Infrastructure') {
            steps {
                echo 'Planning Terraform changes...'
                bat 'terraform plan -out=tfplan'
            }
        }

        stage('Apply Infrastructure') {
            steps {
                input message: 'Approve deployment to AWS?'
                echo 'Applying Terraform plan...'
                bat 'terraform apply -auto-approve tfplan'
            }
        }

        stage('Verify Deployment') {
            steps {
                echo 'Verifying resources on AWS...'
                bat 'terraform output'
            }
        }

        stage('Cleanup (Optional)') {
            when {
                expression { return params.DESTROY == true }
            }
            steps {
                input message: 'Destroy resources?'
                echo 'Destroying Terraform-managed resources...'
                bat 'terraform destroy -auto-approve'
            }
        }
    }

    post {
        success {
            echo '✅ Terraform deployment succeeded!'
        }
        failure {
            echo '❌ Terraform deployment failed!'
        }
    }
}
