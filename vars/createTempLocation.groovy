#!/usr/bin/env groovy

def call(String path) {
  String tmpDir = pwd tmp: true
  return WORKSPACE + '/scripts/' + path
}