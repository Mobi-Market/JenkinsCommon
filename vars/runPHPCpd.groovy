#!/usr/bin/env groovy

def call(Map config) {
	sh(copyGlobalLibraryScript('phpcpd.sh'))
	def checkstyle = scanForIssues pattern: 'reports/**/phpcpd.pmd.xml', reportEncoding: '', sourceCodeEncoding: '', tool: [$class: 'Pmd']
	publishIssues id: 'copyPaste', name: 'Copy Paste Detection', issues:[checkstyle],  healthy: 10000, unHealthy: 9000
}