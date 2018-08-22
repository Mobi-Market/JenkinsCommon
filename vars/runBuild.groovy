#!/usr/bin/env groovy

def call(Map config) {
	def script = libraryResource 'build.sh'

	sh script
}