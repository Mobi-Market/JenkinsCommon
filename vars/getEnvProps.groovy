#!/usr/bin/env groovy

/** split a properties map into an array of environment variables suitable for use with withEnv **/
@NonCPS
def getEnvFromProps(props) {
    def dlist = []
    for (entry in props) {
        envstr = entry.key + '=' + entry.value
        dlist.add(envstr)
    }
    return dlist
}

def call(Map config, Closure body) {
    def fileName = config?.filename ?: 'Artifacts/build.properties'
    def defaults = config?.defaults ?: [GITDESCRIBE: 'Developer Version', GIT_BRANCH: 'Developer Build', PRODUCT_VERSION: '0.0.1', GIT_REVISION_COUNT: 1, BUILD_NUMBER]

    def props = readProperties defaults: defaults, file: fileName;
    def e = getEnvFromProps(props);

	echo e.toString()
	withEnv(e) {
		body()
	}
}