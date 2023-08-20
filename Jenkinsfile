@Library('jenkins-shared-library@main') _

pipeline {
    agent none  

    stages {
    
        stage('Build Docker Image') {
            agent {
                docker {
                    image 'techiescamp/base-image:latest'
                    args '-v /var/run/docker.sock:/var/run/docker.sock --privileged '
                    reuseNode true  
                }
            }
            environment {
                DOCKER_CONFIG = '/tmp/docker'
            }
            steps {
                dockerBuild(
                    versionTag: "1.0",
                    imageName: "test-image"
                )
            }
        }

    
    }
}
