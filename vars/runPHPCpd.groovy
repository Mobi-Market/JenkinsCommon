#!/usr/bin/env groovy

def call(Map config) {
	def scriptContent = libraryResource 'phpcpd.sh'
	writeFile file: "phpcpd.sh", text: scriptContent

	sh 'phpcpd.sh'
}