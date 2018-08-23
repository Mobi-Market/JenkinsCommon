#!/usr/bin/env groovy

def call(Map config) {
	def script = copyGlobalLibraryScript('build.sh')
	sh script
}