#!/usr/bin/env groovy

def call(Map config) {
	sh(copyGlobalLibraryScript('phpcs.sh'))
	def checkstyle = scanForIssues tool: [$class: 'CheckStyle'], pattern: 'reports/**/phpcs.checkstyle*.xml'
	publishIssues id: 'checkstyleFull', name: 'Code Sniff (Full)', issues:[checkstyle],  healthy: 10000, unHealthy: 9000
}