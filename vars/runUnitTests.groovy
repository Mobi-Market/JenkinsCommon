#!/usr/bin/env groovy

def call(Map config) {
	withEnv([
        "BUILD_NUMBER="+buildNumber,
        "BRANCH_NAME="+branchName,#
		"TEST_SUITE=JenkinsUnit"
    ]) {
	    sh(copyGlobalLibraryScript('test.sh'))
    }
	def checkstyle = scanForIssues pattern: 'Reports/**/JenkinsUnit-coverage.xml', reportEncoding: '', sourceCodeEncoding: '', tool: [$class: 'CheckStyle']
	publishIssues id: 'copyPaste', name: 'Function Tests', issues:[checkstyle],  healthy: 10000, unHealthy: 9000
}