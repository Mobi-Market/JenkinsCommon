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
	def buildNumber = config?.buildNumber
	def branchName = config?.branchName

	def props = readProperties file: 'git.properties'
	echo props.toString()
	def e = getEnvFromProps(props)
	echo e.toString()

	withEnv(e) {
		sh(copyGlobalLibraryScript('archive.sh'))
		if (fileExists(ArtifactBaseName+'.zip')) {
			fileOperations([fileDeleteOperation(excludes: '', includes: ArtifactBaseName+'.zip')])
		}
		zip archive: true, dir: 'Artifacts', glob: '', zipFile: ArtifactBaseName+'.zip'
	}
}