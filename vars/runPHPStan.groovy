#!/usr/bin/env groovy

def call(Map config) {
	def script = libraryResource 'phpstan.sh'

	sh script
}