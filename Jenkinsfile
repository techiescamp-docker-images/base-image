@Library('jenkins-shared-library@develop') _

def imageName = "terraform-image"
def versionTag = "1.0.0"

pipeline {
    agent{
        label 'AGENT-01'
    }

    stages {
    
        stage('Run Trivy Scan') {
            steps {
                script {
                    try {
                        def imageNameAndTag = "${imageName}:${versionTag}"
                        trivyScan(imageNameAndTag)
                    } catch (Exception trivyError) {
                        currentBuild.result = 'FAILURE'
                        error("Trivy scan failed: ${trivyError}")
                    }
                }
            }
        }
    }
}
