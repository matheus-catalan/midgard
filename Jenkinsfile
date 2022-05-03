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
                    sh 'docker network rm create cosmos-midgard-network'
                    docker.image('postgres:13').inside("-p 5432:5432 --network=cosmos-midgard-network --name comsmos-midgard-test --rm -e POSTGRES_DB=test -e POSTGRES_USER=test -e POSTGRES_PASSWORD=test") { 
                        dockerapp.inside("-p 8080:8080 --network=cosmos-midgard-network --name comsmos-midgard --rm -e POSTGRES_DB=test -e POSTGRES_USER=test -e POSTGRES_PASSWORD=test") { 
                            stage 'Install Gems'
                            sh 'bundle install'
                        }
                    }
                    sh 'docker ps'

                    // $ docker run --restart=always -d --name elasticsearch -p 9200:9200 -e "http.host=0.0.0.0" -e "transport.host=127.0.0.1" docker.elastic.co/elasticsearch/elasticsearch:5.5.2
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
