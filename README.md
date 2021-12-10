[![Infrastructure Tests](https://www.bridgecrew.cloud/badges/github/simonpanw/iac-onboarding-aws/general)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=SimOnPanw%2Fiac-onboarding-aws&benchmark=INFRASTRUCTURE+SECURITY)
[![Infrastructure Tests](https://www.bridgecrew.cloud/badges/github/simonpanw/iac-onboarding-aws/cis_aws)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=SimOnPanw%2Fiac-onboarding-aws&benchmark=CIS+AWS+V1.2)
[![Infrastructure Tests](https://www.bridgecrew.cloud/badges/github/simonpanw/iac-onboarding-aws/soc2)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=SimOnPanw%2Fiac-onboarding-aws&benchmark=SOC2)
[![Infrastructure Tests](https://www.bridgecrew.cloud/badges/github/simonpanw/iac-onboarding-aws/iso)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=SimOnPanw%2Fiac-onboarding-aws&benchmark=ISO27001)

# terraform-onboarding-aws

## Requirement for wsl with ubuntu 

You need to install terraform 0.14 and awscli 

```console
# curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -  
# sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
# sudo apt-get update && sudo apt-get install terraform
# terraform --help
# terraform --version
# terraform -install-autocomplete
# sudo apt install awscli
```

## Authentication to AWS

```console
# aws configure
AWS Access Key ID [None]: [YOUR_AWS_ACCESS_KEY]
AWS Secret Access Key [None]: [YOUR_SUPER_SECRET_KEY]
Default region name [None]: eu-west-1
Default output format [None]:
```

## Execution of terraform script

```console
# terraform init
# terraform plan
# terraform apply
```


## DEMO

```terraform
resource "aws_kms_key" "my_key" {
  description             = "KMS key for CloudWatch"
  deletion_window_in_days = 10
}

resource "aws_cloudwatch_log_group" "cloudwatch-vpc-flowlog" {
  kms_key_id        = aws_kms_key.my_key.key_id
}
```


## Reset demo environment

```console
git checkout main
git branch -D feature/add-kms
git push origin --delete feature/add-kms
```