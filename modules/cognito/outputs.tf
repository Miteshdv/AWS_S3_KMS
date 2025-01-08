output "user_pool_id" {
  value = aws_cognito_user_pool.user_pool.id
}

output "user_pool_client_id" {
  value = aws_cognito_user_pool_client.user_pool_client.id
}

output "identity_pool_id" {
  value = aws_cognito_identity_pool.identity_pool.id
}

output "authenticated_role_arn" {
  value = aws_iam_role.authenticated_role.arn
}

output "unauthenticated_role_arn" {
  value = aws_iam_role.unauthenticated_role.arn
}

output "region" {
  value = var.region
}
