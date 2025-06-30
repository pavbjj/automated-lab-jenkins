pipeline {
  agent any

  parameters {
    choice(name: 'ACTION', choices: ['apply', 'destroy'], description: 'Choose Terraform action')
  }

  environment {
        TF_VAR_url                 = 'https://f5-consult.console.ves.volterra.io/api'
        TF_VAR_prefix              = 'p-kuligowski-jenkins'
        VSPHERE_SERVER             = 'vc-a-waw.gs.lab'
        VSPHERE_USER               = 'pkuligowski'
    }

  stages {
    stage('Checkout') {
      steps {
        git branch: 'main', url: 'https://github.com/pavbjj/automated-lab-jenkins.git'
      }
    }

    stage('Terraform Init') {
      steps {
        dir('vmware-singe-nic-smsv2') {
          withCredentials([
            file(credentialsId: 'api_cert_file', variable: 'API_CERT_FILE'),
            file(credentialsId: 'api_key_file', variable: 'API_KEY_FILE'),
            string(credentialsId: 'VSPHERE_PASSWORD', variable: 'VSPHERE_PASSWORD')

          ]) {
            sh '''
              export TF_VAR_api_cert=$API_CERT_FILE
              export TF_VAR_api_key=$API_KEY_FILE
              export TF_VAR_VSPHERE_PASSWORD=$VSPHERE_PASSWORD

              terraform init
            '''
          }
        }
      }
    }

    stage('Terraform Apply') {
      steps {
        dir('vmware-singe-nic-smsv2') {
          withCredentials([
            file(credentialsId: 'api_cert_file', variable: 'API_CERT_FILE'),
            file(credentialsId: 'api_key_file', variable: 'API_KEY_FILE'),
            string(credentialsId: 'VSPHERE_PASSWORD', variable: 'VSPHERE_PASSWORD')
          ]) {
            script {
              def tfCommand = params.ACTION == 'destroy' ? 'terraform plan -destroy' : 'terraform plan'

              sh '''
              export TF_VAR_api_cert=$API_CERT_FILE
              export TF_VAR_api_key=$API_KEY_FILE
              export TF_VAR_VSPHERE_PASSWORD=$VSPHERE_PASSWORD

               ''' + "\n${tfCommand}"
            }
          }
        }
      }
    }

    stage('Terraform Apply/Destroy') {
      steps {
        dir('vmware-singe-nic-smsv2') {
          withCredentials([
            file(credentialsId: 'api_cert_file', variable: 'API_CERT_FILE'),
            file(credentialsId: 'api_key_file', variable: 'API_KEY_FILE'),
            file(credentialsId: 'VSPHERE_PASSWORD', variable: 'VSPHERE_PASSWORD')
          ]) {
            script {
              def tfCommand = params.ACTION == 'destroy' ? 'terraform destroy -auto-approve' : 'terraform apply -auto-approve'

              sh '''
              export TF_VAR_api_cert=$API_CERT_FILE
              export TF_VAR_api_key=$API_KEY_FILE
              export TF_VAR_VSPHERE_PASSWORD=$VSPHERE_PASSWORD
            
              ''' + "\n${tfCommand}"
            }
          }
        }
      }
    }
  }

 
  post {
    failure {
      echo "Terraform ${params.ACTION} failed."
    }
    success {
      script {
        echo "Terraform ${params.ACTION} completed successfully."
        currentBuild.displayName = "#${env.BUILD_NUMBER} - ${params.ACTION}"
        currentBuild.description = "Terraform ${params.ACTION} completed at ${new Date()}"
      }
    }
  }
}
