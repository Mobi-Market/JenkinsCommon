#!/usr/bin/env groovy

def call(Map config) {
	sh(copyGlobalLibraryScript('document.sh'))
	sh(copyGlobalLibraryScript('phpdoc.sh'))
}