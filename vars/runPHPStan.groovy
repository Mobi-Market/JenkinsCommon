#!/usr/bin/env groovy

def call(Map config) {
	sh(copyGlobalLibraryScript('phpstan.sh'))
	def checkstyle = scanForIssues tool: checkStyle(pattern: 'reports/phpstan.checkstyle.xml')
	publishIssues id: 'PHPStan', name: 'PHP Stan', issues:[checkstyle],  healthy: 20, unHealthy: 21
}