#!/usr/bin/env groovy

def call(Map config) {
	sh(libraryResource('build.sh'))
}