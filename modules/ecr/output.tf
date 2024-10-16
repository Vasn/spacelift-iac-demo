output "ecr_repo_url" {
  value = { for repo_name, ecr in aws_ecr_repository.main : repo_name => ecr.repository_url }
}