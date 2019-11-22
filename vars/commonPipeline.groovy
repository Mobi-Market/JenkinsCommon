#!/usr/bin/env groovy

def call(Map pipelineParams) {
    properties ([[$class: 'BuildDiscarderProperty', strategy: [$class: 'LogRotator', artifactDaysToKeepStr: '', artifactNumToKeepStr: '', daysToKeepStr: '7', numToKeepStr: '']]])
    /** Some hard coded defaults for common build variables. These should all be replaced by the actual build scripts **/
    def defaults = [GITDESCRIBE: 'Developer Version', GIT_BRANCH: 'Developer Build', PRODUCT_VERSION: '0.0.1', GIT_REVISION_COUNT: 1, BRANCH_NAME: env.BRANCH_NAME, BUILD_NUMBER: env.BUILD_NUMBER]

    def ArtifactBaseName = pipelineParams.system
    def BuildName = env.BRANCH_NAME + ' ' + env.BUILD_DISPLAY_NAME + '(Build)';
    def buildKey = 'Build_' + BUILD_NUMBER;

    pipeline {
        agent any
        stages {
            stage('Build') {
                steps {
                    timestamps {
                        checkout scm
                        script {
                            commit = sh(returnStdout: true, script: 'git rev-parse HEAD')
                        }

                        echo "Commit SHA: ${commit}"

                        notify( key: buildKey, name: BuildName, commit: commit, system: JOB_BASE_NAME, step: 'Build') {
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

                        notify( key: buildKey, name: BuildName, commit: commit, system: JOB_BASE_NAME, step: 'UnitTest') {
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

                        notify( key: buildKey, name: BuildName, commit: commit, system: JOB_BASE_NAME, step: 'FunctionalTest') {
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
                        notify( key: buildKey, name: BuildName, commit: commit, system: JOB_BASE_NAME, step: 'Static Analysis') {
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
                        notify( key: buildKey, name: BuildName, commit: commit, system: JOB_BASE_NAME, step: 'Copy Paste Detector') {
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
                        notify( key: buildKey, name: BuildName, commit: commit, system: JOB_BASE_NAME, step: 'Code Fixer') {
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
            //             notify( key: buildKey, name: BuildName) {
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
                        notify( key: buildKey, name: BuildName, commit: commit, system: JOB_BASE_NAME, step: 'Package') {
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
                        notify( key: buildKey, name: BuildName, commit: commit, system: JOB_BASE_NAME, step: 'Archive') {
                            runArchive(baseName: ArtifactBaseName, buildNumber: env.BUILD_NUMBER, branchName: env.BRANCH_NAME)
                        }

                        stash includes: '**', name: 'RelToTag'
                    }
                }
            }
            stage('Tagging') {
                steps {
                    timestamps {
                        prepareWorkSpace(stashName: 'RelToTag')
                        notify( key: buildKey, name: BuildName, commit: commit, system: JOB_BASE_NAME, step: 'Tagging') {
                            runTagging(buildNumber: env.BUILD_NUMBER, branchName: env.BRANCH_NAME)
                        }
                    }
                }
            }
        }
    }
}