pipeline {
    agent any

    environment {
        // Use Jenkins credentials (type: AWS Credentials)
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
        TF_WORKING_DIR = './'  // Folder with Terraform files
    }

    parameters {
        booleanParam(name: 'DESTROY', defaultValue: false, description: 'Destroy infrastructure after verification?')
    }

    stages {
        stage('Checkout Code') {
            steps {
                echo 'Fetching latest code from GitHub...'
                git branch: 'main', url: 'https://github.com/Sakshid27/terraform-aws-project1.git'
            }
        }

        stage('Initialize Terraform') {
            steps {
                echo 'Initializing Terraform...'
                dir("${TF_WORKING_DIR}") {
                    bat 'terraform init'
                }
            }
        }

        stage('Plan Infrastructure') {
            steps {
                echo 'Planning Terraform changes...'
                dir("${TF_WORKING_DIR}") {
                    bat 'terraform plan -out=tfplan'
                }
            }
        }

        stage('Apply Infrastructure') {
            steps {
                input message: 'Approve deployment to AWS?'
                echo 'Applying Terraform plan...'
                dir("${TF_WORKING_DIR}") {
                    bat 'terraform apply -auto-approve tfplan'
                }
            }
        }

        stage('Verify Deployment') {
            steps {
                echo 'Verifying resources on AWS...'
                dir("${TF_WORKING_DIR}") {
                    bat 'terraform output'
                }
            }
        }

        stage('Cleanup (Optional)') {
            when {
                expression { return params.DESTROY == true }
            }
            steps {
                input message: 'Destroy resources?'
                echo 'Destroying Terraform-managed resources...'
                dir("${TF_WORKING_DIR}") {
                    bat 'terraform destroy -auto-approve'
                }
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
