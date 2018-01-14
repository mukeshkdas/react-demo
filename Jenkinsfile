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
                    git 'https://github.com/sushanthmangalore/react-demo.git'
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
                    sh '''docker ps -q --filter ancestor=sushanthmangalore/reactapp
                    container=$(docker ps -q --filter ancestor=sushanthmangalore/reactapp)
                    if [ -n "$container" ]; then
                        docker stop $container
                        docker rm -f $container
                    fi'''
                    withDockerRegistry([url:'',credentialsId: '5f1ec9fe-d2ae-4d05-9284-0112bb14978d']) {
                        sh '''image=$(docker images --filter=reference="sushanthmangalore/reactapp" --format "{{.ID}}")
                              if [ -n "$image" ]; then
                                docker tag $image sushanthmangalore/reactapp:previous
                                docker push sushanthmangalore/reactapp
                                docker rmi -f $image
                              fi'''
                    }
            }
        }
        stage('Deploy') {
             steps{
               sh 'docker build -t sushanthmangalore/reactapp .'
               sh 'docker run -d -p 3000:3000 sushanthmangalore/reactapp'
            }
        }
        stage('Smoke Test') {
             steps{
                 sleep time: 2000, unit: 'MILLISECONDS'
                 sh '''echo "Success" > file1
                        status=$(curl -sI \'http://ec2-52-66-194-198.ap-south-1.compute.amazonaws.com:3000/\' | head -n 1 | awk \'{print $2}\')
                        echo $status
                        if [ $status -ne 200 ]; then
                            echo "Failure" > file1
                            docker ps -q --filter ancestor=sushanthmangalore/reactapp
                            container=$(docker ps -q --filter ancestor=sushanthmangalore/reactapp)
                            if [ -n "$container" ]; then
                                docker stop $container
                                docker rm -f $container
                            fi
                            image=$(docker images --filter=reference="sushanthmangalore/reactapp" --format "{{.ID}}")
                            if [ -n "$image" ]; then
                                docker rmi -f $image
                            fi
                            docker pull sushanthmangalore/reactapp:previous
                            docker run -d -p 3000:3000 sushanthmangalore/reactapp
                        fi'''
                        script {
                             jobStatus = readFile('file1');
                             jobStatus = jobStatus.trim();
                        }
            }
        }
        stage('Notify') {
            steps{
                    script {
                        if(jobStatus=='Failure'){
                            mail bcc: '', body: 'The deployment was not successful. The old version of the app has been restored.', cc: '', from: '', replyTo: '', subject: 'Deployment Status: Failed', to: 'sushanth.mlr@gmail.com'
                        }else{
                            mail bcc: '', body: 'The deployment was completed successfully. The new version of the app can be accessed at the URL - http://ec2-52-66-194-198.ap-south-1.compute.amazonaws.com:3000/', cc: '', from: '', replyTo: '', subject: 'Deployment Status: Success', to: 'sushanth.mlr@gmail.com'
                        }
                    }
            }
        }
   }
    post { 
        failure { 
            mail bcc: '', body: "The deployment pipeline has failed. Review the job here - ${env.BUILD_URL}", cc: '', from: '', replyTo: '', subject: 'Deployment Status', to: 'sushanth.mlr@gmail.com'
        }
    }
}