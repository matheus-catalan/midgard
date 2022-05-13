pipeline {
    agent any
    environment {
        NAME_CONTAINER_SERVICE_TEST = "midgard"
        NAME_NETWORK = "cosmo_network"
        NAME_CONTAINER_DB_TEST = "db"
        POSTGRES_DB = "test"
        POSTGRES_USER = "test"
        POSTGRES_PASSWORD = "test"
        REPOSITORY_IMAGE_NAME = "matheuscatalan123/cosmos-midgard"
    }
    stages {
        stage ('Build Image') {
            steps {
                script {
                    def slackResponse = slackSend(color: "good", message: "[${String.format('%tF %<tH:%<tM', java.time.LocalDateTime.now())}] - <${env.BUILD_URL}|Build Started - ${env.BUILD_NUMBER}> ")

                    blocks = [
                        [
                            "type": "section",
                            "text": [
                                "type": "mrkdwn",
                                "text": "Hello, Assistant to the Regional Manager Dwight! *Michael Scott* wants to know where you'd like to take the Paper Company investors to dinner tonight.\n\n *Please select a restaurant:*"
                            ]
                        ],
                        [
                            "type": "divider"
                        ],
                        [
                            "type": "section",
                            "text": [
                                "type": "mrkdwn",
                                "text": "*Farmhouse Thai Cuisine*\n:star::star::star::star: 1528 reviews\n They do have some vegan options, like the roti and curry, plus they have a ton of salad stuff and noodles can be ordered without meat!! They have something for everyone here"
                            ],
                            "accessory": [
                                "type": "image",
                                "image_url": "https://s3-media3.fl.yelpcdn.com/bphoto/c7ed05m9lC2EmA3Aruue7A/o.jpg",
                                "alt_text": "alt text for image"
                            ]
                        ]
                    ]

                    slackSend(color: "good", blocks: blocks)

                    dockerapp = docker.build("$REPOSITORY_IMAGE_NAME:base", ".")
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
                        sh 'RAILS_ENV=test bundle exec rspec spec --format RspecJunitFormatter --out tmp/rspec.xml --format html --out tmp/rspec.html'

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
                    version = readFile('.version')

                    docker.withRegistry("https://registry.hub.docker.com", "dockerhub") {
                        version = readFile('.version')
                        dockerapp.push('latest')
                        dockerapp.push(version)
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
            script {
                def images_id = sh(returnStdout: true, script: "/usr/bin/docker images registry.hub.docker.com/$REPOSITORY_IMAGE_NAME -aq")
                sh "docker rm -f ${NAME_CONTAINER_DB_TEST} ${NAME_CONTAINER_SERVICE_TEST}"
                sh "docker network rm $NAME_NETWORK"
                
                sh "docker rmi -f $images_id"
            }

        }
    }
}


