#!/usr/bin/env groovy

def call(Map config, Closure body) {
	def BuildName = config?.name ?: '(unknown)'
	def buildKey = config?.key ?: 'unknown'
	def system = config?.channel ?: 'general'

	if (system == 'MobiMarket') {
		system = 'lifeboat'
	}
	
	bitbucketStatusNotify( buildKey: buildKey, buildName: BuildName, buildState: 'INPROGRESS')
	try {
		body()
		bitbucketStatusNotify( buildKey: buildKey, buildName: BuildName, buildState: 'SUCCESSFUL')
	}
	catch (err) {
		bitbucketStatusNotify( buildKey: buildKey,buildName: BuildName, buildState: 'FAILED', buildDescription: err.toString())
		throw err
	}
}
