#!/usr/bin/env groovy

def call(String path) {
  String tmpDir = pwd tmp: true
  return tmpDir + File.separator + path
}