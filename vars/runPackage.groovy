#!/usr/bin/env groovy

def call(Map config) {
	def scriptContent = libraryResource 'package.sh'
	writeFile file: "package.sh", text: scriptContent

	sh 'package.sh'
}