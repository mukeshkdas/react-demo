pipeline {
   agent {
        node {
            label 'docker-agent'
        }
   }
   stages{
        stage('Code Checkout') { 
            steps{
                    sh 'pwd'
                    git credentialsId: 'GitHub', url: 'https://github.com/sushanthmangalore/react-demo.git'
            }
        }
        stage('Install dependencies') { 
            steps{
                    sh 'pwd'
                    sh 'ls -lrt /home/app'
                    sh 'pwd'
                    sh 'cp -Rf /home/app ./node_modules'
                    sh 'ls -lrt ./node_modules'
            }
        }
        stage('Code Quality') {
            steps{
                sh 'npm run eslint'
            }
        }
        stage('Tests') {
             steps{
               sh 'npm t'
            }
        }
        stage('Undeploy') {
             steps{
                    withDockerRegistry([url:'',credentialsId: '5f1ec9fe-d2ae-4d05-9284-0112bb14978d']) {
                        sh '''
                              ls -lrt
                              latest=`docker images | grep -e "sushanthmangalore/reactapp" | grep  -e "latest" | awk '{print $3}'`
                              echo $latest
                              image=`docker images | grep -e "sushanthmangalore/reactapp" | grep -v "${latest}" | awk '{print $3}' | tail -1`
                              if [ -n "$image" ]; then
                                docker tag $image sushanthmangalore/reactapp:previous
                                docker push sushanthmangalore/reactapp:previous
                                docker rmi -f $image
                              fi'''
                    }
            }
        }
        stage('Deploy') {
             steps{
               withCredentials([usernamePassword(credentialsId: 'GitHub', passwordVariable: 'pwd', usernameVariable: 'uid')]) {
                  sh '''
                    version=`docker images | grep "sushanthmangalore/reactapp" | grep -v -e "latest" -e "previous" | awk '{print $2}'`  
                    echo ${version}
                    version=$((version+1))
                    docker build -t sushanthmangalore/reactapp:latest -t sushanthmangalore/reactapp:${version} .
                    docker service update --image sushanthmangalore/reactapp:${version} --update-delay 30s reactapp
                '''    
               }
            }
        }
   }
    post { 
        failure { 
            mail bcc: '', body: "The deployment pipeline has failed. Review the job here - ${env.BUILD_URL}", cc: '', from: '', replyTo: '', subject: 'Deployment Status: Failed', to: 'sushanth.mlr@gmail.com'
        }
        success { 
            mail bcc: '', body: "The deployment pipeline completed successfully. The new version of the app can be accessed at the URL - http://ec2-52-66-194-198.ap-south-1.compute.amazonaws.com:3000/", cc: '', from: '', replyTo: '', subject: 'Deployment Status: Success', to: 'sushanth.mlr@gmail.com'
        }
    }
}