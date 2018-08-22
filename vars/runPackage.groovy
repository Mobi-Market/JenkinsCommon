#!/usr/bin/env groovy

def call(Map config) {
	def script = libraryResource 'package.sh'
	sh script
}