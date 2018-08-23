#!/usr/bin/env groovy

def call(String srcPath, String destPath = null) {
  destPath = destPath ?: createTempLocation(srcPath)
  writeFile file: destPath, text: libraryResource(srcPath)
  echo "copyGlobalLibraryScript: copied ${srcPath} to ${destPath}"
  sh "chmod +x ${destPath}"
  echo "added executable permissions to ${destPath}"
  return destPath
}