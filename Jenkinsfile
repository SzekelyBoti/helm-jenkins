pipeline {
    agent any

    environment {
        KUBECONFIG = credentials('kubeconfig-id')
    }

    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Set Kubeconfig') {
            steps {
                withCredentials([file(credentialsId: 'kubeconfig-id', variable: 'KUBECONFIG_FILE')]) {
                    script {
                        env.KUBECONFIG = KUBECONFIG_FILE
                    }
                }
            }
        }

        stage('Helm Deploy') {
            steps {
                script {
                    sh '''
                    # Deploy Prometheus and Grafana
                    helm upgrade --install monitoring ./helm-app- -f ./helm-app-/values.yaml --namespace monitoring --create-namespace
        
                    # Deploy Tweet App
                    helm upgrade --install tweet-app ./helm-app-/tweet-app -f ./helm-app-/tweet-app/values.yaml --namespace default --create-namespace
                    '''
                }
            }
        }

        stage('Verify Deployment') {
            steps {
                script {
                    sh 'kubectl get pods -n default'
                }
            }
        }
    }

    post {
        success {
            echo 'Deployment completed successfully!'
        }
        failure {
            echo 'Deployment failed!'
        }
    }
}
