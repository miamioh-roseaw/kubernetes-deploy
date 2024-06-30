pipeline {
    agent any
    environment {
        PROXMOX_API_URL = 'https://your-proxmox-server:8006/api2/json'
        PROXMOX_USERNAME = 'root@pam'
        PROXMOX_PASSWORD = credentials('proxmox-password') // Store your Proxmox password in Jenkins credentials
        PROXMOX_NODE = 'your-proxmox-node'
        TERRAFORM_DIR = 'terraform/proxmox-k8s-cluster' // Path to your Terraform scripts
        KUBECONFIG = "${env.WORKSPACE}/kubeconfig"
    }
    stages {
        stage('Checkout') {
            steps {
                git 'https://your-repo-url.git'
            }
        }
        stage('Terraform Init') {
            steps {
                dir("${env.TERRAFORM_DIR}") {
                    script {
                        withCredentials([usernamePassword(credentialsId: 'proxmox-api-credentials', passwordVariable: 'PROXMOX_PASSWORD', usernameVariable: 'PROXMOX_USERNAME')]) {
                            sh 'terraform init'
                        }
                    }
                }
            }
        }
        stage('Terraform Apply') {
            steps {
                dir("${env.TERRAFORM_DIR}") {
                    script {
                        withCredentials([usernamePassword(credentialsId: 'proxmox-api-credentials', passwordVariable: 'PROXMOX_PASSWORD', usernameVariable: 'PROXMOX_USERNAME')]) {
                            sh 'terraform apply -auto-approve'
                        }
                    }
                }
            }
        }
        stage('Configure Kubernetes') {
            steps {
                script {
                    // Assuming Terraform outputs the kubeconfig content to a file or variable
                    dir("${env.TERRAFORM_DIR}") {
                        sh 'terraform output -raw kubeconfig > ${KUBECONFIG}'
                    }
                    sh 'kubectl get nodes --kubeconfig=${KUBECONFIG}'
                }
            }
        }
    }
    post {
        always {
            cleanWs()
        }
        success {
            echo 'Kubernetes cluster setup is complete!'
        }
        failure {
            echo 'Something went wrong!'
        }
    }
}
