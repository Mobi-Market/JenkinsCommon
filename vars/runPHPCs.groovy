#!/usr/bin/env groovy

def call(Map config) {
	def scriptContent = libraryResource 'phpcs.sh'
	writeFile file: "phpcs.sh", text: scriptContent

	sh 'phpcs.sh'
}