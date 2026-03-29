pipeline {
    agent any

    environment {
        AWS_DEFAULT_REGION = 'us-east-1'
        TF_IN_AUTOMATION   = 'true'
        TF_DIR             = 'Class-Assignments/new-jenkins-s3-test'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
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
                            pwd
                            ls -la
                            terraform init
                        '''
                    }
                }
            }
        }

        stage('Terraform Plan and Apply') {
            steps {
                dir("${TF_DIR}") {
                    withCredentials([[
                        $class: 'AmazonWebServicesCredentialsBinding',
                        credentialsId: 'larry'
                    ]]) {
                        sh '''
                            terraform plan -out=tfplan
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
                                sh 'terraform destroy -auto-approve'
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