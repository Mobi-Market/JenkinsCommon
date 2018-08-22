#!/usr/bin/env groovy

def call(Map pipelineParams) {
    def ArtifactBaseName = pipelineParams.system
    def BuildName = env.BRANCH_NAME + ' ' + env.BUILD_DISPLAY_NAME + '(Build)';
    def buildKey = 'Build';

    pipeline {
        agent LINUX
        stages {
            stage('Build') {
                timestamps {
                    checkout scm

                    bbNotify( key: buildKey, name: BuildName) {
                        runBuild()
                    }

                    stash includes: '**', name: 'RelToSTAN'
                }
            },
            stage('Static Analysis') {
                timestamps {
                    prepareWorkspace(stashName: 'RelToSTAN')
                    bbNotify( key: buildKey, name: BuildName) {
                        runPHPStan()
                    }

                    stash includes: '**', name: 'RelToCPD'
                }
            },
            stage('Copy Paste Detector') {
                timestamps {
                    prepareWorkspace(stashName: 'RelToCPD')
                    bbNotify( key: buildKey, name: BuildName) {
                        runPHPCpd()
                    }

                    stash includes: '**', name: 'RelToCS'
                }
            },
            stage('Code Sniffer') {
                timestamps {
                    prepareWorkspace(stashName: 'RelToCS')
                    bbNotify( key: buildKey, name: BuildName) {
                        runPHPCs()
                    }

                    stash includes: '**', name: 'RelToDocument'
                }
            },
            stage('Documentation') {
                timestamps {
                    prepareWorkspace(stashName: 'RelToDocument')
                    bbNotify( key: buildKey, name: BuildName) {
                        runDocument()
                    }

                    stash includes: '**', name: 'RelToPackage'
                }
            },
            stage('Package') {
                timestamps {
                    prepareWorkspace(stashName: 'RelToPackage')
                    bbNotify( key: buildKey, name: BuildName) {
                        runPackage()
                    }

                    stash includes: '**', name: 'RelToArchive'
                }
            },
            stage('Archive') {
                timestamps {
                    prepareWorkspace(stashName: 'RelToArchive')
                    bbNotify( key: buildKey, name: BuildName) {
                        runArchive(baseName: ArtifactBaseName)
                    }

                    stash includes: '**', name: 'RelToTag'
                }
            },
            stage('Tagging') {
                timestamps {
                    prepareWorkspace(stashName: 'RelToTag')
                    bbNotify( key: buildKey, name: BuildName) {
                        runTagging(buildNumber: env.BUILD_NUMBER, branchName: env.BRANCH_NAME)
                    }
                }
            }
        }
    }
}