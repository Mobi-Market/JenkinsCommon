#!/usr/bin/env groovy

def call(Map config) {
    def buildNumber = config?.buildNumber
    def branchName = config?.branchName
	def script = libraryResource 'tagging.sh'
    withEnv([
        "BUILD_NUMBER="+buildNumber,
        "BRANCH_NAME="+branchName
    ]) {
	    sh script
    }
    
}