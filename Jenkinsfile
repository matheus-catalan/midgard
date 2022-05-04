pipeline {
    agent any

    stages {
        stage ('Build Image') {
            steps {
                script {
                    dockerapp = docker.build("matheuscatalan123/cosmos-midgard:${env.BUILD_ID}", ".")
                }
            }
        }

        stage ('Run Containers to test') {
            steps {
                script {
                    sh "docker network ls|grep cosmos_network > /dev/null || docker network create cosmos_network"
                    docker.image('postgres:13').run('-it --rm --name db-test --network=cosmos_network -e POSTGRES_DB=test -e POSTGRES_USER=test -e POSTGRES_PASSWORD=test -p 5433:5432 -d', '-p 5433')
                    // $ docker run --restart=always -d --name elasticsearch -p 9200:9200 -e "http.host=0.0.0.0" -e "transport.host=127.0.0.1" docker.elastic.co/elasticsearch/elasticsearch:5.5.2
                }
            }
        }

        stage ('Run Tests') {
            steps {
                script {
                    dockerapp.run("--network=cosmos_network --name cosmos-midgard -p 8080:8080", "rspec")
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
