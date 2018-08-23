#!/usr/bin/env groovy

def call(Map config) {
	sh(copyGlobalLibraryScript('build.sh'))
}