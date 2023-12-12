resource "aws_codepipeline" "deployment_pipeline" {
  name     = "ecr-push"
  role_arn = aws_iam_role.role.arn
  tags = {
    Environment = "dev"
  }
  stage {
    name = "Source"
    action {
      name             = "SourceAction"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["Source"]

      configuration = {
        OAuthToken    = ""
        Owner         = "momina"
        Repo          = "https://github.com/momina-mk/AWS-CICD-ECS_deployment.git"
        Branch        = "main"
        PollForSourceChanges = "false" # Optional: Set to "true" for periodic checks
      }
    }
  }
