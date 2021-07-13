#!/usr/bin/env groovy

def call(Map config) {
    def buildNumber = config?.buildNumber
    def branchName = config?.branchName

    withCredentials([usernamePassword(credentialsId: 'd08f94eb-fc16-489f-a320-0b694689846f', passwordVariable: 'GIT_PASSWORD', usernameVariable: 'GIT_USER')]) {
        withEnv([
            "BUILD_NUMBER="+buildNumber,
            "BRANCH_NAME="+branchName
        ]) {
            sh(copyGlobalLibraryScript('tagging.sh'))
        }
    }

}