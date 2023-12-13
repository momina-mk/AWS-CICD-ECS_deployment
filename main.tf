terraform {
  required_version = ">= 0.14.9"
}
provider "aws" {
  region = var.region
}
resource "aws_s3_bucket" "cicd-bucket" {
  bucket        = "cicdbucketmomina"
  force_destroy = true
}
resource "aws_codebuild_project" "codebuild_project" {
  name          = var.codebuild_name
  description   = "Codebuild demo with Terraform"
  build_timeout = "120"
  service_role  = aws_iam_role.containerAppBuildProjectRole.arn

  artifacts {
    encryption_disabled = true
    packaging           = "NONE"
    type                = "CODEPIPELINE"
  }

  source {
   buildspec = file("buildspec.yml")

    git_clone_depth     = 0
    insecure_ssl        = false
    report_build_status = false
    type                = "CODEPIPELINE" 

    git_submodules_config {
      fetch_submodules = true
    }
  }

  environment {
    image                       = lookup(var.codebuild_params, "IMAGE")
    type                        = lookup(var.codebuild_params, "TYPE")
    compute_type                = lookup(var.codebuild_params, "COMPUTE_TYPE")
    image_pull_credentials_type = lookup(var.codebuild_params, "CRED_TYPE")
    privileged_mode             = true

    dynamic "environment_variable" {
      for_each = var.environment_variables
      content {
        name  = environment_variable.key
        value = environment_variable.value
      }
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "log-group"
      stream_name = "log-stream"
    }

    s3_logs {
      status = "DISABLED"
    }
  }
}
