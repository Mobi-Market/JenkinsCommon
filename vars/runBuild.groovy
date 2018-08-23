#!/usr/bin/env groovy

def call(Map config) {
	def scriptContent = libraryResource 'build.sh'
	writeFile file: "build.sh", text: scriptContent
	
	sh "build.sh"
}