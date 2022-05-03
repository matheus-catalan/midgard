pipeline {
    agent any

    stages {
        stage ('Build Image') {
            steps {
                script {
                    dockerapp = docker.build("matheuscatalan123/comsmos-midgard:${env.BUILD_ID}", ".")
                }
            }
        }

        stage ('Run Test') {
            steps {
                script {
                    docker.image('postgres:13').withRun { container -> 
                        echo "PostgreSQL running in container ${container.id}" 
                    }
                }
            }
        }

        // stage ('Push Image') {
        //     steps {
        //         script {
        //             docker.withRegistry("https://registry.hub.docker.com", "dockerhub") {
        //                 dockerapp.push('latest')
        //                 dockerapp.push("${env.BUILD_ID}")
        //             }
        //         }
        //     }
        // }
    }
}
