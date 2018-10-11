@Library('standardLibraries') _

def scmVars

pipeline {
    agent any
    options {
        timestamps()
        disableConcurrentBuilds()
    }
    environment {
        MOLECULE_EPHEMERAL_DIRECTORY = "${WORKSPACE}/.molecule"
    }
    stages {
        stage('Code checkout'){
            steps {
                script {
                    scmVars = checkout scm
                    notify([ type: "slack-default-start" ])
                }
            }
        }
        stage('Create python virtualenv'){
            steps{
                ansiColor('xterm') {
                    echo "\u001B[32mBuilding virtualenv ...\u001B[0m"
                    sh script: """
                        set +x
                        virtualenv -p /usr/bin/python2.7 .venv
                        source .venv/bin/activate
                        pip install --upgrade -r requirements.txt
                    """
                }
            }
        }
        stage('Molecule role scenario setup'){
            steps{
                ansiColor('xterm') {
                    echo "\u001B[32mSetting up role scenario ...\u001B[0m"
                    withCredentials([usernamePassword(credentialsId: 'ost-admin', passwordVariable: 'OS_PASSWORD', usernameVariable: 'OS_USERNAME')]) {
                        sh script: """
                            set +x
                            [ -e \$VIRTUAL_ENV ] && source .venv/bin/activate
                            molecule create
                        """
                    }
                }
            }
        }
        stage('Molecule role test'){
            steps{
                ansiColor('xterm') {
                    echo "\u001B[32mTesting ansible role ...\u001B[0m"
                    withCredentials([usernamePassword(credentialsId: 'ost-admin', passwordVariable: 'OS_PASSWORD', usernameVariable: 'OS_USERNAME')]) {
                        sh script: """
                            set +x
                            [ -e \$VIRTUAL_ENV ] && source .venv/bin/activate
                            molecule converge
                        """

                        sh script: """
                            set +x
                            [ -e \$VIRTUAL_ENV ] && source .venv/bin/activate
                            molecule idempotence
                        """
                    }
                }
            }
        }
    }
    post{
        always{
            withCredentials([usernamePassword(credentialsId: 'ost-admin', passwordVariable: 'OS_PASSWORD', usernameVariable: 'OS_USERNAME')]) {
                sh script: """
                    set +x
                    [ -e \$VIRTUAL_ENV ] && source .venv/bin/activate
                    molecule destroy
                """
            }
            script {
                notify([ type: "slack-default-end" ])
            }
            deleteDir()
        }
    }
}
