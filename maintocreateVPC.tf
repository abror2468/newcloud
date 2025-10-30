resource "aws_s3_bucket" "my_first_bucket" {
  bucket = "abror-first-terraform-bucket"
  tags = {
    name = "MyFirstTerraformBucket"
  }
}
