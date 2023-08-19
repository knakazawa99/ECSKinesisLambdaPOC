terraform {
  backend "s3" {
    bucket  = "ecs-kinesis-lambda-poc-bucket"
    key     = "tfstate"
    region  = "ap-northeast-1"
    profile = "saml"
  }
}
