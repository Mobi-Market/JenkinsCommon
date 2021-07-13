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
	if (system == 'MobiInsurance') {
		system = 'fulfilment'
	}

	echo "Notifying GH for system: ${system}"

	// githubNotify account: 'Mobi-Market', context: buildKey, credentialsId: 'b345f1bc-cf1d-4024-bba6-64b66a0f2881', description: 'Starting ' + step + ' Step', gitApiUrl: '', repo: system, status: 'PENDING'
	githubNotify account: 'Mobi-Market', context: buildKey, credentialsId: '1ff0d140-8690-4233-9ff5-870d3e648cae', description: 'Starting ' + step + ' Step', gitApiUrl: '', repo: system, status: 'PENDING'
	try {
		body()
		// githubNotify account: 'Mobi-Market', context: buildKey, credentialsId: 'b345f1bc-cf1d-4024-bba6-64b66a0f2881', description: 'Finished ' + step + ' Step', gitApiUrl: '', repo: system, status: 'SUCCESS'
		githubNotify account: 'Mobi-Market', context: buildKey, credentialsId: '1ff0d140-8690-4233-9ff5-870d3e648cae', description: 'Finished ' + step + ' Step', gitApiUrl: '', repo: system, status: 'SUCCESS'
	}
	catch (err) {
		echo err.toString();
		// githubNotify account: 'Mobi-Market', context: buildKey, credentialsId: 'b345f1bc-cf1d-4024-bba6-64b66a0f2881', description: 'Error ' + step + ': ' + err.toString(), gitApiUrl: '', repo: system, status: 'FAILURE'
		githubNotify account: 'Mobi-Market', context: buildKey, credentialsId: '1ff0d140-8690-4233-9ff5-870d3e648cae', description: 'Error ' + step + ' Step', gitApiUrl: '', repo: system, status: 'FAILURE'
		throw err
	}
}
