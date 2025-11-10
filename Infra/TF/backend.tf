terraform {
  backend "s3" {
    bucket = "config-bucket-865673179293"
    key    = "tf-test"
    region = "ap-south-1"
  }
}
