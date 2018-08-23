#!/usr/bin/env groovy

def call(Map config) {
	def ArtifactBaseName = config?.baseName

	def scriptContent = libraryResource 'archive.sh'
	writeFile file: "archive.sh", text: scriptContent

	def props = readProperties defaults: defaults, file: 'git.properties'
	echo props.toString()
	def e = getEnvFromProps(props)
	echo e.toString()
	
	withEnv(e) {
		sh 'archive.sh'
		zip dir: 'Artifacts', glob: '', zipFile: 'Artifacts/'+ArtifactBaseName+'-'+env.GITDESCRIBE+'.zip'
	}

    archive 'Artifacts/**'
    step([$class: 'Fingerprinter', targets: 'Artifacts/**'])
}