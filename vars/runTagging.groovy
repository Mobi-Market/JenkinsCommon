#!/usr/bin/env groovy

def call(Map config) {
    def buildNumber = config?.buildNumber
    def branchName = config?.branchName
    
    withCredentials([usernamePassword(credentialsId: '5554a026-150a-4f90-867a-e069defc3aca', passwordVariable: 'GIT_PASSWORD', usernameVariable: 'GIT_USER')]) {
        withEnv([
            "BUILD_NUMBER="+buildNumber,
            "BRANCH_NAME="+branchName
        ]) {
            sh(copyGlobalLibraryScript('tagging.sh'))
        }
    }
    
}