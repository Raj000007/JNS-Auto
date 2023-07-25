pipeline {
    agent any
    tools {
        maven "MAVEN_HOME"
        jdk "JAVA_HOME"
    }
    environment {
        SNAP_REPO = 'snapshot'
        NEXUS_USER = 'admin'
        NEXUS_PASS = 'admin'
        RELEASE_REPO = 'release'
        CENTRAL_REPO = 'central'
        NEXUSIP = '172.31.83.213'
        NEXUSPORT = '8081'
        NEXUS_GRP_REPO = 'group'
        NEXUS_LOGIN = 'nexus'
        SONARSERVER = 'sonarserver'
        SONARSCANNER = 'sonarscanner'
    }
    stages {
    
    stage('Build') {
            steps {
                sh 'mvn -s settings.xml -DskipTests install -U'
            }
            post {
                success {
                    echo "Now Archiving."
                    archiveArtifacts artifacts: '**/*.war'
                }
            }
        }
stage('Test') {
           steps {
            sh 'mvn test'
           }
        }
        
        stage('Checkstyle Analysis'){
            steps {
                sh 'mvn -s settings.xml checkstyle:checkstyle'
            }
        }


 stage('CODE ANALYSIS with SONARQUBE') {
          
          environment {
             scannerHome = tool "${SONARSCANNER}"
          }
          steps {
            withSonarQubeEnv("${SONARSERVER}") 
              {
               sh '''${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=JNS \
                   -Dsonar.projectName=JNS \
                   -Dsonar.projectVersion=1.0 \
                   -Dsonar.sources=src/ \
                   -Dsonar.java.binaries=target/test-classes/com/visualpathit/account/controllerTest/ \
                   -Dsonar.junit.reportsPath=target/surefire-reports/ \
                   -Dsonar.jacoco.reportsPath=target/jacoco.exec \
                   -Dsonar.java.checkstyle.reportPaths=target/checkstyle-result.xml'''
            }
          }
       }

stage('UPLOAD ARTIFACT') {
                steps {
                    nexusArtifactUploader(
                        nexusVersion: 'nexus3',
                        protocol: 'http',
                        nexusUrl: "${NEXUSIP}:${NEXUSPORT}",
                        groupId: 'QA',
                        version: "${env.BUILD_ID}-${env.BUILD_TIMESTAMP}",
                        repository: "${RELEASE_REPO}",
                        credentialsId: "${NEXUS_LOGIN}",
                        artifacts: [
                            [artifactId: 'vproapp' ,
                            classifier: '',
                            file: 'target/vprofile-v2.war',
                            type: 'war']
                        ]
                    )
                }
     }


        
}
     post {
        always {
            // This block will run always, regardless of the build result
            echo "Post-build: Sending Slack notification..."
            slackSend(channel: '#devops', color: 'good', message: "Jenkins build successful: ${currentBuild.fullDisplayName}")
        }
        
        success {
            // This block will run only if the build is successful
            echo "Post-build: Build successful"
            // Additional actions for successful builds
        }
        
        failure {
            // This block will run only if the build fails
            echo "Post-build: Build failed"
            // Additional actions for failed builds
        }
        
        unstable {
            // This block will run only if the build is unstable
            echo "Post-build: Build unstable"
            // Additional actions for unstable builds
        }
        
        // Add more post-build actions as needed
    }

}
