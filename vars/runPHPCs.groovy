#!/usr/bin/env groovy

def call(Map config) {
	def script = libraryResource 'phpcs.sh'

	sh script
}