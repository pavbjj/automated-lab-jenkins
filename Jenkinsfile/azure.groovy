pipeline {
  agent any

  parameters {
    choice(name: 'ACTION', choices: ['apply', 'destroy'], description: 'Choose Terraform action')
  }

  stages {
    stage('Checkout') {
      steps {
        git branch: 'main', url: 'https://github.com/pavbjj/automated-lab-jenkins.git'
      }
    }

    stage('Terraform Init') {
      steps {
        dir('azure-vnet-subnets') {
          withCredentials([
            usernamePassword(credentialsId: 'azure_creds', usernameVariable: 'TF_VAR_client_id', passwordVariable: 'TF_VAR_client_secret'),
            string(credentialsId: 'subscription_id', variable: 'TF_VAR_subscription_id'),
            string(credentialsId: 'tenant_id', variable: 'TF_VAR_tenant_id')
          ]) {
            sh '''
              export ARM_CLIENT_ID=$TF_VAR_client_id
              export ARM_CLIENT_SECRET=$TF_VAR_client_secret
              export ARM_SUBSCRIPTION_ID=$TF_VAR_subscription_id
              export ARM_TENANT_ID=$TF_VAR_tenant_id

              terraform init -upgrade
            '''
          }
        }
      }
    }

    stage('Terraform Plan') {
      steps {
        dir('azure-vnet-subnets') {
          withCredentials([
            usernamePassword(credentialsId: 'azure_creds', usernameVariable: 'TF_VAR_client_id', passwordVariable: 'TF_VAR_client_secret'),
            string(credentialsId: 'subscription_id', variable: 'TF_VAR_subscription_id'),
            string(credentialsId: 'tenant_id', variable: 'TF_VAR_tenant_id')
          ]) {
            script {
              def tfCommand = params.ACTION == 'destroy' ? 'terraform plan -destroy' : 'terraform plan'

              sh '''
                export ARM_CLIENT_ID=$TF_VAR_client_id
                export ARM_CLIENT_SECRET=$TF_VAR_client_secret
                export ARM_SUBSCRIPTION_ID=$TF_VAR_subscription_id
                export ARM_TENANT_ID=$TF_VAR_tenant_id
              ''' + "\n${tfCommand}"
            }
          }
        }
      }
    }

    stage('Terraform Apply/Destroy') {
      steps {
        dir('azure-vnet-subnets') {
          withCredentials([
            usernamePassword(credentialsId: 'azure_creds', usernameVariable: 'TF_VAR_client_id', passwordVariable: 'TF_VAR_client_secret'),
            string(credentialsId: 'subscription_id', variable: 'TF_VAR_subscription_id'),
            string(credentialsId: 'tenant_id', variable: 'TF_VAR_tenant_id')
          ]) {
            script {
              def tfCommand = params.ACTION == 'destroy' ? 'terraform destroy -auto-approve' : 'terraform apply -auto-approve'

              sh '''
                export ARM_CLIENT_ID=$TF_VAR_client_id
                export ARM_CLIENT_SECRET=$TF_VAR_client_secret
                export ARM_SUBSCRIPTION_ID=$TF_VAR_subscription_id
                export ARM_TENANT_ID=$TF_VAR_tenant_id

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
