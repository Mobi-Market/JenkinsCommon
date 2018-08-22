#!/usr/bin/env groovy

def call(Map config) {
	def stashName = config?.stashName
	def artifactsDirName = config?.artifactsDirName ?: 'Artifacts'

    dir(artifactsDirName) {
        deleteDir()
    }
    unstash stashName
}
