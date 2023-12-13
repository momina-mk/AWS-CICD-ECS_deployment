variable "region" {
  description = "Region"
  type        = string
  default     = "us-east-1"
}

variable "prop_tags" {
  description = "Tags"
  type        = map(string)
  default = {
    Project = "Codebuild Terraform"
    IaC     = "Terraform"
  }
}

variable "account_id" {
  description = "AWS Account ID"
  type        = string
}

variable "codebuild_name" {
  description = "Codebuild project name"
  type        = string
  default     = "codebuild-demo-terraform"
}

variable "codebuild_params" {
  description = "Codebuild parameters"
  type        = map(string)
}

variable "environment_variables" {
  description = "Environment variables"
  type        = map(string)
}
variable "git_token" {
  description = "github public access token"
  type        = string
  default     = "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"
}