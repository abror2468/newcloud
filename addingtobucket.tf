# Enable static website hosting on your existing bucket
resource "aws_s3_bucket_website_configuration" "my_first_bucket" {
  bucket = aws_s3_bucket.my_first_bucket.id

  index_document { suffix = "index.html" }
  error_document { key    = "error.html" }
}

# Relax bucket-level Public Access blocks so a public-read policy can work
resource "aws_s3_bucket_public_access_block" "my_first_bucket" {
  bucket                  = aws_s3_bucket.my_first_bucket.id
  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = false
  restrict_public_buckets = false
}

# Public-read policy so the website is viewable by anyone
data "aws_iam_policy_document" "public_read" {
  statement {
    sid     = "AllowPublicRead"
    effect  = "Allow"
    actions = ["s3:GetObject"]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    resources = ["${aws_s3_bucket.my_first_bucket.arn}/*"]
  }
}

resource "aws_s3_bucket_policy" "public" {
  bucket = aws_s3_bucket.my_first_bucket.id
  policy = data.aws_iam_policy_document.public_read.json
}

# Optional: seed content
resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.my_first_bucket.id
  key          = "index.html"
  content      = "<h1>Hello from S3 Static Website!</h1>"
  content_type = "text/html"
}

resource "aws_s3_object" "error" {
  bucket       = aws_s3_bucket.my_first_bucket.id
  key          = "error.html"
  content      = "<h1>Not Found</h1>"
  content_type = "text/html"
}

# Website URL output
output "website_url" {
  value       = aws_s3_bucket_website_configuration.my_first_bucket.website_endpoint
  description = "Open this URL to view the site (HTTP)"
}
