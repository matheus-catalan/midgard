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
                    sh "docker network ls|grep $NAME_NETWORK > /dev/null || docker network create $NAME_NETWORK"
                    sh "docker rm -f $NAME_CONTAINER_DB_TEST $NAME_CONTAINER_SERVICE_TEST > /dev/null"
                    docker.image('postgres:13').run(
                        "-it --rm --name $NAME_CONTAINER_DB_TEST " + 
                        "--network=$NAME_NETWORK " + 
                        "-v /databases/db-test/:/var/lib/postgresql/data/ " +
                        "-e POSTGRES_DB=$POSTGRES_DB " + 
                        "-e POSTGRES_USER=$POSTGRES_USER " + 
                        "-e POSTGRES_PASSWORD=$POSTGRES_PASSWORD "+ 
                        "-p 5433:5432 -d", 
                        '-p 5433'
                    )
                    sh 'cp .docker/application.yml ./config'
                    // $ docker run --restart=always -d --name elasticsearch -p 9200:9200 -e "http.host=0.0.0.0" -e "transport.host=127.0.0.1" docker.elastic.co/elasticsearch/elasticsearch:5.5.2
                }
            }
        }

        stage ('Run Tests and report results and coverage') {
            steps {
                script {
                    dockerapp.inside("--network=$NAME_NETWORK --name $NAME_CONTAINER_SERVICE_TEST -p 8181:8080 -u root:root") {
                        sh 'RAILS_ENV=test bundle exec rspec spec --format RspecJunitFormatter --out tmp/rspec.xml --format progress --out tmp/rspec.txt'

                        // archive includes: 'pkg/*.gem'

                        publishHTML target: [
                            allowMissing: false,
                            alwaysLinkToLastBuild: false,
                            keepAll: true,
                            reportDir: 'coverage',
                            reportFiles: 'index.html',
                            reportName: 'RCov Report'
                        ]
                    }
                }
            }

            post {
                always {
                    junit 'tmp/rspec.xml'
                }
            }
        }

        stage ('Push Image') {
            steps {
                script {
                    docker.withRegistry("https://registry.hub.docker.com", "dockerhub") {
                        dockerapp.push('latest')
                        dockerapp.push("${env.BUILD_ID}")
                    }
                }
            }
        }

    }
    post {
        success {
           slackSend(color: "good", message: "[${String.format('%tF %<tH:%<tM', java.time.LocalDateTime.now())}] - <${env.BUILD_URL}|Build deployed successfully - ${env.BUILD_NUMBER}>")
        }
        failure {
            slackSend(color: "danger", failOnError:true, message:"[${String.format('%tF %<tH:%<tM', java.time.LocalDateTime.now())}] - <${env.BUILD_URL}|Build failed  - ${env.BUILD_NUMBER} >")
        }
        always {
            sh "docker rm -f ${NAME_CONTAINER_DB_TEST} ${NAME_CONTAINER_SERVICE_TEST}"
            sh "docker network rm $NAME_NETWORK"

        }
    }
}


