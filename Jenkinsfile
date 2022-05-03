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
                    sh "docker-compose -f .docker/docker-compose.test.yml up --build -d"
                    // $ docker run --restart=always -d --name elasticsearch -p 9200:9200 -e "http.host=0.0.0.0" -e "transport.host=127.0.0.1" docker.elastic.co/elasticsearch/elasticsearch:5.5.2
                }
            }
        }

        stage ('Run Tests') {
            steps {
                script {
                    dockerapp.inside("-p 8181:8080 --network=cosmos_network --name comsmos-midgard --rm -e POSTGRES_DB=test -e POSTGRES_USER=test -e POSTGRES_PASSWORD=test") {
                        sh 'usermod -aG root jenkins'
                        sh 'cat /etc/group'
                        sh 'ls -la /usr/local/bundle/'
                        sh 'bundle'
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
