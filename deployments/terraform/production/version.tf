/*---------------------------------------------------------------------------------------
© 2022 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
 
This AWS Content is provided subject to the terms of the AWS Customer Agreement
available at http://aws.amazon.com/agreement or other written agreement between
Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.
---------------------------------------------------------------------------------------*/

#currently Terraform has not support ap-southeast-3
# Issue: https://github.com/hashicorp/terraform-provider-aws/issues/22252

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"

      version = ">= 3.8, != 3.14.0"
    }
    template = {
      source = "hashicorp/template"
    }
    time = {
      source = "hashicorp/time"
    }
  }

  backend "s3" {
    # Replace this with your bucket name!
    bucket                 = "mysiloam-prod-terraform-state" #"<Your Bucket Name>"
    key                    = "terraform-states/svc-Mysiloam-prod-ecs-hello-world/terraform.tfstate"
    region                 = "ap-southeast-3" #"<Your Region>"
    skip_region_validation = true
    # Not mandatory
    # profile                 = "santosoc-cgk" #"<Your AWS Profile>"

    # Replace this with your DynamoDB table name!
    dynamodb_table = "mysiloam-prod-terraform-state" #"<Your Dynamo DB>"
    encrypt        = true
  }

  required_version = ">= 0.13"
}


# Configure the AWS Provider
provider "aws" {
  region                 = var.region #"<Your Region>"
  skip_region_validation = true
  # Not mandatory
  # profile = "santosoc-cgk" #"<Your AWS Profile>"
  default_tags {
    tags = {
      Service      = var.service_name
      Managed_Via  = "TerraformManaged"
      Environment  = var.environment
      Owner        = var.application_name
      compliance   = "true"
      map-migrated = "mig40404"
    }
  }
}


data "aws_caller_identity" "current" {}

data "terraform_remote_state" "infrastructure" {
  backend = "s3"
  config = {
    bucket = "mysiloam-prod-terraform-state" #"<Your Bucket Name>"
    key    = "terraform-states/mysiloam-prod-terraform-state/terraform.tfstate"
    region = var.region #"<Your Region>"

    # profile = "santosoc-cgk" #"<Your AWS Profile>"
  }
}

locals {
  # Account id
  account_id                    = data.aws_caller_identity.current.account_id
  alb_public_security_group_id  = data.terraform_remote_state.infrastructure.outputs.lb_public_securitygroup
  alb_private_security_group_id = data.terraform_remote_state.infrastructure.outputs.lb_private_securitygroup

  tags = var.tags
}
