resource "aws_codepipeline" "deployment_pipeline" {
  depends_on = [ aws_ecs_cluster.deployment_cluster, aws_ecs_service.deployment_service ]
  name     = "ecr-push"
  role_arn = aws_iam_role.codepipeline.arn
  tags = {
    Environment = "dev"
  }
  artifact_store {
    location = aws_s3_bucket.cicd-bucket.id
    type     = "S3"
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
# The configuration will form a sequence for github repo like owner/repo, so it should be according to the repository
      configuration = {
        Branch     = "main"
        Repo       = "AWS-CICD-ECS_deployment"
        OAuthToken = var.git_token
        Owner      = "momina-mk"
      }
      run_order = 1
    }
  }
  stage {
    name = "Build"
    action {
      name             = "Build"
      category         = "Build"
      input_artifacts  = ["Source"]
      output_artifacts = ["Build"]
      owner            = "AWS"
      provider         = "CodeBuild"
      run_order        = 1
      version          = "1"
      configuration = {
        "ProjectName" = aws_codebuild_project.codebuild_project.name
      }
    }
  }
 
  stage {
    name = "Deploy"
    action {
      category        = "Deploy"
      name            = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeployToECS"
      version         = "1"
      input_artifacts = ["Build"]

      configuration = {
        ApplicationName                = aws_codedeploy_app.this.name
        DeploymentGroupName            = aws_codedeploy_deployment_group.this.deployment_group_name
        AppSpecTemplateArtifact        = "Build"
        AppSpecTemplatePath            = "appspec.yaml"
        TaskDefinitionTemplateArtifact = "Build"       
        TaskDefinitionTemplatePath     = "taskdef.json" 
      }
    }
  }
}
