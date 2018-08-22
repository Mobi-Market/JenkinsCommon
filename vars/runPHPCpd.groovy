#!/usr/bin/env groovy

def call(Map config) {
	def script = libraryResource 'phpcpd.sh'

	sh script
}