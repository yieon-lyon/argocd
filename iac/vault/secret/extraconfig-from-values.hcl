disable_mlock = true
ui = true

listener "tcp" {
  tls_disable = 1
  address = "[::]:8200"
  cluster_address = "[::]:8201"
}
storage "s3" {
  access_key = "AWS_ACCESS_KEY"
  secret_key = "AWS_SECRET_KEY"
  bucket     = "aws-vault"
  region     = "ap-northeast-2" # your region
  kms_key_id = "alias/aws/s3"
}