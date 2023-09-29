@Library('jenkins-shared-library@develop') _

pipeline {
    agent {
        label 'AGENT-01'
    }

    stages {
        stage('Lint Dockerfile') {
            steps {
                hadoLint()
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    try {
                        dockerBuild(
                            imageName: 'docker-base-image'
                        )
                    } catch (Exception buildError) {
                        currentBuild.result = 'FAILURE'
                        error("Failed to build Docker image: ${buildError}")
                    }
                }
            }
        }
        stage('Run Trivy Scan') {
            steps {
                script {
                    try {
                        def imageName = "docker-base-image"
                        trivyScan(imageName)
                    } catch (Exception trivyError) {
                        currentBuild.result = 'FAILURE'
                        error("Trivy scan failed: ${trivyError}")
                    }
                }
            }
        }
        stage('Send Trivy Report') {
            steps {
                script {
                    try {
                        def reportPath = "${WORKSPACE}/trivy-report.html"
                        def recipient = "aswin@crunchops.com"
                        emailReport(reportPath, recipient)
                    } catch (Exception emailError) {
                        currentBuild.result = 'FAILURE'
                        error("Email Send failed: ${emailError}")
                    }
                }
            }
        }
        stage('Push Image To ECR') {
            when {
                branch 'main'
            }
            steps {
                script {
                    try {
                        ecrRegistry(
                            imageName: 'docker-base-image',
                            repoName: 'base-image',
                        )
                    } catch (Exception pushError) {
                        currentBuild.result = 'FAILURE'
                        error("Failed to push image to ECR: ${pushError}")
                    }
                }
            }
        }
    }

    post {
        success {
            script {
                emailNotification.sendEmailNotification('success', 'aswin@crunchops.com')
            }
        }
        failure {
            script {
                emailNotification.sendEmailNotification('failure', 'aswin@crunchops.com')
            }
        }
        always {
            cleanWs()
        }
    }
}
