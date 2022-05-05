pipeline {
    agent any
    environment {
        NAME_CONTAINER_SERVICE_TEST = "midgard"
        NAME_CONTAINER_DB_TEST = "db"
        POSTGRES_DB = "test"
        POSTGRES_USER = "test"
        POSTGRES_PASSWORD = "test"
    }
    stages {
        stage ('Build Image') {
            steps {
                script {
                    dockerapp = docker.build("matheuscatalan123/cosmos-midgard:base", ".")
                }
            }
        }

        stage ('Preparing workspace to run the tests') {
            steps {
                script {
                    sh "docker network ls|grep $NAME_CONTAINER_SERVICE_TEST > /dev/null || docker network create $NAME_CONTAINER_SERVICE_TEST"
                    docker.image('postgres:13').run("-it --rm --name $NAME_CONTAINER_DB_TEST --network=$NAME_CONTAINER_SERVICE_TEST -e POSTGRES_DB=$POSTGRES_DB -e POSTGRES_USER=$POSTGRES_USER -e POSTGRES_PASSWORD=$POSTGRES_PASSWORD -p 5433:5432 -d", '-p 5433')
                    // $ docker run --restart=always -d --name elasticsearch -p 9200:9200 -e "http.host=0.0.0.0" -e "transport.host=127.0.0.1" docker.elastic.co/elasticsearch/elasticsearch:5.5.2
                }
            }
        }

        // stage ('Run Tests') {
        //     steps {
        //         script {
        //             dockerapp.run("--network=cosmos_network --name midgard", "rspec")
        //         }
        //     }
        // }

        // stage ('Cleanup Containers') {
        //     steps {
        //         script {
        //             // sh "docker rm -f $(docker ps -a -q)"
        //         }
        //     }
        // }

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
