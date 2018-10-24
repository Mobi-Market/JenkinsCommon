#!/usr/bin/env groovy

def call(Map config) {
	withEnv([
        "BUILD_NUMBER="+buildNumber,
        "BRANCH_NAME="+branchName,
		"TEST_SUITE=JenkinsFunctional"
    ]) {
	    sh(copyGlobalLibraryScript('test.sh'))
    }
	def checkstyle = scanForIssues pattern: 'Reports/**/JenkinsFunctional-coverage.xml', reportEncoding: '', sourceCodeEncoding: '', tool: [$class: 'CheckStyle']
	publishIssues id: 'functionaltests', name: 'Function Tests', issues:[checkstyle],  healthy: 10000, unHealthy: 9000
}