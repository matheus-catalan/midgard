pipeline {
    agent any
    environment {
        NAME_CONTAINER_SERVICE_TEST = "midgard"
        NAME_NETWORK = "cosmo_network"
        NAME_CONTAINER_DB_TEST = "db"
        POSTGRES_DB = "test"
        POSTGRES_USER = "test"
        POSTGRES_PASSWORD = "test"
    }
    stages {
        stage ('Build Image') {
            steps {
                script {
                    def slackResponse = slackSend(color: "good", message: "[${String.format('%tF %<tH:%<tM', java.time.LocalDateTime.now())}] - <${env.BUILD_URL}|Build Started - ${env.BUILD_NUMBER}>")
                    dockerapp = docker.build("matheuscatalan123/cosmos-midgard:base", ".")
                }
            }
        }

        stage ('Preparing workspace to run the tests') {
            steps {
                script {
                    
                    sh "echo '==> Create network $NAME_NETWORK to test'"
                    sh "docker network ls|grep $NAME_NETWORK > /dev/null || docker network create $NAME_NETWORK"
                    
                    sh "echo '==> Remove old containers'"
                    sh "docker rm -f $NAME_CONTAINER_DB_TEST $NAME_CONTAINER_SERVICE_TEST > /dev/null"

                    sh "echo '==> Create databases $NAME_CONTAINER_DB_TEST to test'"
                    docker.image('postgres:13').run(
                        "-it --rm --name $NAME_CONTAINER_DB_TEST " + 
                        "--network=$NAME_NETWORK " + 
                        "-e POSTGRES_DB=$POSTGRES_DB " + 
                        "-e POSTGRES_USER=$POSTGRES_USER " + 
                        "-e POSTGRES_PASSWORD=$POSTGRES_PASSWORD "+ 
                        "-p 5433:5432 -d", 
                        '-p 5433'
                    )
                    // $ docker run --restart=always -d --name elasticsearch -p 9200:9200 -e "http.host=0.0.0.0" -e "transport.host=127.0.0.1" docker.elastic.co/elasticsearch/elasticsearch:5.5.2
                }
            }
        }

        stage ('Run Tests') {
            steps {
                script {
                    dockerapp.inside("--network=$NAME_NETWORK --name $NAME_CONTAINER_SERVICE_TEST -p 8181:8080 ") {
                        sh 'bundle install'
                        // sh 'rspec --format progress --format RspecJunitFormatter --out tmp/rspec.xml'
                        sh 'RAILS_ENV=test rspec --format progress'
                    }
                }
            }

            post {
                always {
                    junit 'tmp/rspec.xml'
                }
            }
        }

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
    post {
        success {
           slackSend(color: "good", message: "[${String.format('%tF %<tH:%<tM', java.time.LocalDateTime.now())}] - <${env.BUILD_URL}|Build deployed successfully - ${env.BUILD_NUMBER}>")
        }
        failure {
            slackSend(color: "danger", failOnError:true, message:"[${String.format('%tF %<tH:%<tM', java.time.LocalDateTime.now())}] - <${env.BUILD_URL}|Build failed  - ${env.BUILD_NUMBER} >")
        }
    }
}


