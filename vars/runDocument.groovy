#!/usr/bin/env groovy

def call(Map config) {
	def script = libraryResource 'document.sh'

	sh script
}