pipeline {
    agent any

    environment {
        AWS_DEFAULT_REGION = 'us-east-1'
        TF_IN_AUTOMATION   = 'true'
        TF_DIR             = '.'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
                sh '''
                    pwd
                    ls -la
                '''
            }
        }

        stage('Verify Environment') {
            steps {
                sh '''
                    set -e
                    whoami
                    terraform version
                    aws --version
                '''
            }
        }

        stage('Terraform Init') {
            steps {
                dir("${TF_DIR}") {
                    withCredentials([[
                        $class: 'AmazonWebServicesCredentialsBinding',
                        credentialsId: 'larry'
                    ]]) {
                        sh '''
                            set -e
                            terraform init
                        '''
                    }
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir("${TF_DIR}") {
                    withCredentials([[
                        $class: 'AmazonWebServicesCredentialsBinding',
                        credentialsId: 'larry'
                    ]]) {
                        sh '''
                            set -e
                            terraform plan -out=tfplan
                        '''
                    }
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir("${TF_DIR}") {
                    withCredentials([[
                        $class: 'AmazonWebServicesCredentialsBinding',
                        credentialsId: 'larry'
                    ]]) {
                        sh '''
                            set -e
                            terraform apply -auto-approve tfplan
                        '''
                    }
                }
            }
        }

        stage('Optional Destroy') {
            steps {
                script {
                    def destroyChoice = input(
                        message: 'Do you want to run terraform destroy?',
                        ok: 'Submit',
                        parameters: [
                            choice(
                                name: 'DESTROY',
                                choices: ['no', 'yes'],
                                description: 'Select yes to destroy resources'
                            )
                        ]
                    )

                    if (destroyChoice == 'yes') {
                        dir("${TF_DIR}") {
                            withCredentials([[
                                $class: 'AmazonWebServicesCredentialsBinding',
                                credentialsId: 'larry'
                            ]]) {
                                sh '''
                                    set -e
                                    terraform destroy -auto-approve
                                '''
                            }
                        }
                    } else {
                        echo 'Skipping destroy'
                    }
                }
            }
        }
    }
}
