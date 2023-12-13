account_id = "979490057625"
codebuild_params = {
  "NAME"         = "codebuild-demo-terraform"
  "GIT_REPO"     = "https://github.com/momina-mk/AWS-CICD-ECS_deployment.git"
  "IMAGE"        = "aws/codebuild/standard:4.0"
  "TYPE"         = "LINUX_CONTAINER"
  "COMPUTE_TYPE" = "BUILD_GENERAL1_SMALL"
  "CRED_TYPE"    = "CODEBUILD"
}
environment_variables = {
  "AWS_DEFAULT_REGION" = "us-east-1"
  "AWS_ACCOUNT_ID"     = "979490057625"
  "IMAGE_REPO_NAME"    = "app-repo"
  "IMAGE_TAG"          = "latest"
}