#!/usr/bin/env groovy

def call(Map config) {
	withEnv([
        "PHP_EXEC="+phpversion
    ]) {
		def script = copyGlobalLibraryScript('build.sh')
		sh script
    }
}