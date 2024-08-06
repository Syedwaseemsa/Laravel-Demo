pipeline {
    agent any

    environment {
        AWS_ECR_REPOSITORY_URI = '381492028434.dkr.ecr.us-east-2.amazonaws.com/demo-laravel'
        IMAGE_NAME = 'lap-app2'
        AWS_REGION = 'us-east-2' // Change to your region
    }

    stages {
        stage('Clone Repository') {
            steps {
                git 'https://github.com/syedwaseemsa/laravel-app.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("${AWS_ECR_REPOSITORY_URI}:${env.BUILD_ID}")
                }
            }
        }

        stage('Login to Amazon ECR') {
            steps {
                script {
                    sh '''
                    aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${AWS_ECR_REPOSITORY_URI}
                    '''
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    dockerImage.push("${env.BUILD_ID}")
                }
            }
        }

        stage('Clean up') {
            steps {
                sh 'docker rmi ${AWS_ECR_REPOSITORY_URI}:${BUILD_ID}'
            }
        }
    }
}
