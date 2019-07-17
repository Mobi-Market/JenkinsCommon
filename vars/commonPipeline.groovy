#!/usr/bin/env groovy

def call(Map pipelineParams) {
    properties ([[$class: 'BuildDiscarderProperty', strategy: [$class: 'LogRotator', artifactDaysToKeepStr: '', artifactNumToKeepStr: '', daysToKeepStr: '7', numToKeepStr: '']]])
    /** Some hard coded defaults for common build variables. These should all be replaced by the actual build scripts **/
    def defaults = [GITDESCRIBE: 'Developer Version', GIT_BRANCH: 'Developer Build', PRODUCT_VERSION: '0.0.1', GIT_REVISION_COUNT: 1, BRANCH_NAME: env.BRANCH_NAME, BUILD_NUMBER: env.BUILD_NUMBER]

    def ArtifactBaseName = pipelineParams.system
    def BuildName = env.BRANCH_NAME + ' ' + env.BUILD_DISPLAY_NAME + '(Build)';
    def buildKey = 'Build';
    def slackchannel = pipelineParams.system

    pipeline {
        agent any
        stages {
            stage('Build') {
                steps {
                    timestamps {
                        checkout scm

                        bbNotify( key: buildKey, name: BuildName, channel: slackchannel) {
                            runBuild()
                        }

                        stash includes: '**', name: 'RelToUnit'
                    }
                }
            }
            stage('UnitTest') {
                steps {
                    timestamps {
                        prepareWorkSpace(stashName: 'RelToUnit')

                        bbNotify( key: buildKey, name: BuildName, channel: slackchannel) {
                            runUnitTests()
                        }

                        stash includes: '**', name: 'RelToFunctional'
                    }
                }
            }
            stage('FunctionalTest') {
                steps {
                    timestamps {
                        prepareWorkSpace(stashName: 'RelToFunctional')

                        bbNotify( key: buildKey, name: BuildName, channel: slackchannel) {
                            runFunctionalTests()
                        }

                        stash includes: '**', name: 'RelToSTAN'
                    }
                }
            }
            stage('Static Analysis') {
                steps {
                    timestamps {
                        prepareWorkSpace(stashName: 'RelToSTAN')
                        bbNotify( key: buildKey, name: BuildName, channel: slackchannel) {
                            runPHPStan()
                        }

                        stash includes: '**', name: 'RelToCPD'
                    }
                }
            }
            stage('Copy Paste Detector') {
                steps {
                    timestamps {
                        prepareWorkSpace(stashName: 'RelToCPD')
                        bbNotify( key: buildKey, name: BuildName, channel: slackchannel) {
                            runPHPCpd()
                        }

                        stash includes: '**', name: 'RelToCS'
                    }
                }
            }
            stage('Code Fixer') {
                steps {
                    timestamps {
                        prepareWorkSpace(stashName: 'RelToCS')
                        bbNotify( key: buildKey, name: BuildName, channel: slackchannel) {
                            runFixer()
                        }

                        stash includes: '**', name: 'RelToPackage'
                    }
                }
            }
            // stage('Documentation') {
            //     steps {
            //         timestamps {
            //             prepareWorkSpace(stashName: 'RelToDocument')
            //             bbNotify( key: buildKey, name: BuildName) {
            //                 runDocument()
            //             }

            //             stash includes: '**', name: 'RelToPackage'
            //         }
            //     }
            // }
            stage('Package') {
                steps {
                    timestamps {
                        prepareWorkSpace(stashName: 'RelToPackage')
                        bbNotify( key: buildKey, name: BuildName, channel: slackchannel) {
                            runPackage()
                        }

                        stash includes: '**', name: 'RelToArchive'
                    }
                }
            }
            stage('Archive') {
                steps {
                    timestamps {
                        prepareWorkSpace(stashName: 'RelToArchive')
                        bbNotify( key: buildKey, name: BuildName, channel: slackchannel) {
                            runArchive(baseName: ArtifactBaseName, buildNumber: env.BUILD_NUMBER, branchName: env.BRANCH_NAME)
                        }

                        // stash includes: '**', name: 'RelToTag'
                    }
                }
            }
            // stage('Tagging') {
            //     steps {
            //         timestamps {
            //             prepareWorkSpace(stashName: 'RelToTag')
            //             bbNotify( key: buildKey, name: BuildName) {
            //                 runTagging(buildNumber: env.BUILD_NUMBER, branchName: env.BRANCH_NAME)
            //             }
            //         }
            //     }
            // }
        }
    }
}