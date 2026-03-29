resource "aws_s3_bucket" "frontend" {
  bucket        = "jenkins-bucket-20260322204450920400000001"
  force_destroy = true

  tags = {
    Name = "Jenkins Bucket"
  }
}

resource "aws_s3_bucket_public_access_block" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  block_public_acls       = false
  ignore_public_acls      = false
  block_public_policy     = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "frontend_public" {
  bucket = aws_s3_bucket.frontend.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.frontend.arn}/*"
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.frontend]
}

# ✅ Upload ALL screenshots from subfolder
resource "aws_s3_object" "screenshots" {
  for_each = fileset(path.module, "Screen-Shots/*.png")

  bucket       = aws_s3_bucket.frontend.id
  key          = "uploads/${basename(each.value)}"
  source       = "${path.module}/${each.value}"
  etag         = filemd5("${path.module}/${each.value}")
  content_type = "image/png"
}

# ✅ Upload all markdown docs in root folder
resource "aws_s3_object" "docs" {
  for_each = fileset(path.module, "*.md")

  bucket = aws_s3_bucket.frontend.id
  key    = each.value
  source = "${path.module}/${each.value}"
  etag   = filemd5("${path.module}/${each.value}")
}