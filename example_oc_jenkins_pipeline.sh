node('') {
    stage 'build'
    openshiftBuild(namespace: 'sms', buildConfig: 'sms', showBuildLogs: 'true')
    stage 'deploy'
    openshiftDeploy(namespace: 'sms', deploymentConfig: 'sms')
  //  openshiftScale(namespace: 'sms', deploymentConfig: 'sms',replicaCount: '2')
}
