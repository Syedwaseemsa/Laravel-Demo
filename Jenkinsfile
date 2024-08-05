pipeline {
    agent {
        docker { image 'php:8.0-cli' }
    }

    environment {
        AWS_DEFAULT_REGION = 'us-east-2'
        ECR_REPOSITORY = 'demo-laravel'
        ECR_REPOSITORY_URL = '381492028434.dkr.ecr.us-east-2.amazonaws.com/demo-laravel'
        DOCKER_CREDENTIALS_ID = 'ecr-credentials'  // Update with your actual Jenkins credentials ID
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main',
                    credentialsId: 'Github-ID',
                    url: 'https://github.com/Syedwaseemsa/Laravel-Demo'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'apt-get update && apt-get install -y libxml2-dev'
                sh 'docker-php-ext-install xml dom'
                sh 'php -r "copy(\'https://getcomposer.org/installer\', \'composer-setup.php\');"'
                sh 'php composer-setup.php'
                sh 'php composer.phar install'
            }
        }

        stage('Run Tests') {
            steps {
                sh 'vendor/bin/phpunit'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    def dockerImage = docker.build("${ECR_REPOSITORY}:${env.BUILD_ID}")
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    withAWS(region: "${AWS_DEFAULT_REGION}", credentials: 'aws-credentials-id') {
                        docker.withRegistry('https://${ECR_REPOSITORY_URL}', DOCKER_CREDENTIALS_ID) {
                            dockerImage.push('latest')
                            dockerImage.push(env.BUILD_ID)
                        }
                    }
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}

