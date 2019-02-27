#!/usr/bin/env groovy

def call(Map config) {
	def buildNumber = config?.buildNumber
    def branchName = config?.branchName

	withEnv([
        "BUILD_NUMBER="+buildNumber,
        "BRANCH_NAME="+branchName,
		"COMPOSER_CMD=database-tests"
    ]) {
	    sh(copyGlobalLibraryScript('test.sh'))
    }
	// def checkstyle = scanForIssues pattern: 'Reports/**/JenkinsFunctional-phpunit-junit.xml', reportEncoding: '', sourceCodeEncoding: '', tool: [$class: 'CheckStyle']
	// publishIssues id: 'functionaltests', name: 'Function Tests', issues:[checkstyle],  healthy: 10000, unHealthy: 9000
	// junit 'Reports/**/JenkinsFunctional-phpunit-junit.xml'
	xunit([PHPUnit(deleteOutputFiles: true, failIfNotNew: true, pattern: 'reports/JenkinsDatabase-phpunit-junit.xml', skipNoTestFiles: false, stopProcessingIfError: false)])
	step([
		$class: 'CloverPublisher',
		cloverReportDir: 'reports/coverage/database',
		cloverReportFileName: 'reports/coverage/JenkinsDatabase-coverage.xml',
		healthyTarget: [methodCoverage: 70, conditionalCoverage: 80, statementCoverage: 80],
		unhealthyTarget: [methodCoverage: 50, conditionalCoverage: 50, statementCoverage: 50],
		failingTarget: [methodCoverage: 0, conditionalCoverage: 0, statementCoverage: 0]
	])
}