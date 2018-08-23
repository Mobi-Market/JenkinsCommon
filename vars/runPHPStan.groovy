#!/usr/bin/env groovy

def call(Map config) {
	def scriptContent = libraryResource 'phpstan.sh'
	writeFile file: "phpstan.sh", text: scriptContent

	sh 'phpstan.sh'
}