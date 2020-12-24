#!/usr/bin/env groovy

def call(Map config) {
	def buildNumber = config?.buildNumber
    def branchName = config?.branchName

	withEnv([
        "BUILD_NUMBER="+buildNumber,
        "BRANCH_NAME="+branchName,
		"COMPOSER_CMD=unit-tests"
    ]) {
	    sh(copyGlobalLibraryScript('test.sh'))
    }
	// def checkstyle = scanForIssues pattern: 'Reports/**/JenkinsUnit-phpunit-junit.xml', reportEncoding: '', sourceCodeEncoding: '', tool: [$class: 'CheckStyle']
	// publishIssues id: 'unittests', name: 'Unit Tests', issues:[checkstyle],  healthy: 10000, unHealthy: 9000
	// junit 'Reports/**/JenkinsUnit-phpunit-junit.xml'
	xunit([PHPUnit(deleteOutputFiles: true, failIfNotNew: false,  pattern: 'reports/JenkinsUnit-phpunit-junit.xml', skipNoTestFiles: false, stopProcessingIfError: false)])
	// step([
	// 	$class: 'CloverPublisher',
	// 	cloverReportDir: 'reports/coverage/unit',
	// 	cloverReportFileName: 'reports/coverage/JenkinsUnit-coverage.xml',
	// 	healthyTarget: [methodCoverage: 70, conditionalCoverage: 80, statementCoverage: 80],
	// 	unhealthyTarget: [methodCoverage: 50, conditionalCoverage: 50, statementCoverage: 50],
	// 	failingTarget: [methodCoverage: 0, conditionalCoverage: 0, statementCoverage: 0]
	// ])
}