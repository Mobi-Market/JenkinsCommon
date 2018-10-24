#!/usr/bin/env groovy

def call(Map config) {
	sh(copyGlobalLibraryScript('phpstan.sh'))
	def checkstyle = scanForIssues tool: [$class: 'CheckStyle'], pattern: 'reports/**/phpstan.checkstyle*.xml'
	publishIssues id: 'PHPStan', name: 'Code Sniff (Full)', issues:[checkstyle],  healthy: 10000, unHealthy: 9000
}