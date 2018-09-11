#!/usr/bin/env groovy
def getEnvFromProps(props) {
    def dlist = []
    for (entry in props) {
        envstr = entry.key + '=' + entry.value
        dlist.add(envstr)
    }
    return dlist
}

def call(Map config) {
	def ArtifactBaseName = config?.baseName

	def props = readProperties file: 'git.properties'
	echo props.toString()
	def e = getEnvProps(props)
	echo e.toString()
	
	withEnv(e) {
		sh(copyGlobalLibraryScript('archive.sh'))
		zip dir: 'Artifacts', glob: '', zipFile: 'Artifacts/'+ArtifactBaseName+'-'+env.GITDESCRIBE+'.zip'
	}

    archive 'Artifacts/**'
    step([$class: 'Fingerprinter', targets: 'Artifacts/**'])
}