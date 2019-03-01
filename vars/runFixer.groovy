#!/usr/bin/env groovy

def call(Map config) {
	sh(copyGlobalLibraryScript('phpcsf.sh'))
	def checkstyle = scanForIssues tool: checkStyle(pattern: 'reports/fixer.checkstyle.xml')
	publishIssues id: 'checkstyleFull', name: 'Code Fixer', issues:[checkstyle],  healthy: 25, unHealthy: 26
}