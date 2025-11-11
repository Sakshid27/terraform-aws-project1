pipeline {
    agent any

    environment {
        // Use Jenkins credentials (type: AWS Credentials)
        AWS_ACCESS_KEY_ID     = credentials('aws-creds')
        AWS_SECRET_ACCESS_KEY = credentials('aws-creds')

        // Terraform path on your local system
        TF_PATH = 'C:\\Users\\saksh\\Downloads\\terraform_1.10.5_windows_386\\terraform.exe'
        TF_WORKING_DIR = './'
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
                    bat "\"${TF_PATH}\" init"
                }
            }
        }

        stage('Plan Infrastructure') {
            steps {
                echo 'Planning Terraform changes...'
                dir("${TF_WORKING_DIR}") {
                    bat "\"${TF_PATH}\" plan -out=tfplan"
                }
            }
        }

        stage('Apply Infrastructure') {
            steps {
                input message: 'Approve deployment to AWS?'
                echo 'Applying Terraform plan...'
                dir("${TF_WORKING_DIR}") {
                    bat "\"${TF_PATH}\" apply -auto-approve tfplan"
                }
            }
        }

        stage('Verify Deployment') {
            steps {
                echo 'Verifying resources on AWS...'
                dir("${TF_WORKING_DIR}") {
                    bat "\"${TF_PATH}\" output"
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
                    bat "\"${TF_PATH}\" destroy -auto-approve"
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
