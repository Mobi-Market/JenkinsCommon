#!/usr/bin/env groovy

def call(Map config) {
    def buildNumber = config?.buildNumber
    def branchName = config?.branchName
    
    withEnv([
        "BUILD_NUMBER="+buildNumber,
        "BRANCH_NAME="+branchName
    ]) {
	    sh(copyGlobalLibraryScript('tagging.sh'))
    }
    
}