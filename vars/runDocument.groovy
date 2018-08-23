#!/usr/bin/env groovy

def call(Map config) {
	def scriptContent = libraryResource 'document.sh'
	writeFile file: "document.sh", text: scriptContent

	sh 'document.sh'
}