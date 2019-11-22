#!/usr/bin/env groovy

def call(Map config, Closure body) {
	def BuildName = config?.name ?: '(unknown)'
	def buildKey = config?.key ?: 'unknown'
	def system = config?.system ?: 'general'
	def commit = config?.commit ?: 'none'
	def step = config?.step ?: 'none'

	if (system == 'MobiMarket') {
		system = 'lifeboat'
	}

	if (system == 'GoodBuyTech') {
		system = 'gbt'
	}
	if (system == 'mobi-insurance') {
		system = 'fulfilment'
	}
	
	githubNotify account: 'Mobi-Market', context: buildKey, credentialsId: 'b345f1bc-cf1d-4024-bba6-64b66a0f2881', description: 'Starting ' + step + ' Step', gitApiUrl: '', repo: system, sha: commit, status: 'pending'
	try {
		body()
		githubNotify account: 'Mobi-Market', context: buildKey, credentialsId: 'b345f1bc-cf1d-4024-bba6-64b66a0f2881', description: 'Finished ' + step + ' Step', gitApiUrl: '', repo: system, sha: commit, status: 'success'
	}
	catch (err) {
		githubNotify account: 'Mobi-Market', context: buildKey, credentialsId: 'b345f1bc-cf1d-4024-bba6-64b66a0f2881', description: 'Error ' + step + ': ' + err.toString(), gitApiUrl: '', repo: system, sha: commit, status: 'failure'
		throw err
	}
}
