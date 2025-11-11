pipeline {
    agent any

    environment {
        // Terraform executable path
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

        stage('Verify AWS Credentials') {
            steps {
                echo 'Checking AWS credentials...'
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-creds']]) {
                    bat 'aws sts get-caller-identity'
                }
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
                echo 'Verifying deployed resources...'
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
