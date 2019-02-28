#!/usr/bin/env groovy

def call(Map config) {
	sh(copyGlobalLibraryScript('document.sh'))
	sh(copyGlobalLibraryScript('phpdoc.sh'))
	publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, keepAll: false, reportDir: 'documentation', reportFiles: 'index.html', reportName: 'API Documentation', reportTitles: ''])
}