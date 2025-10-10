locals {
  frontend_files = {
    "index.html" = "text/html",
    "script.js" = "application/javascript",
    "style.css" = "text/css"
  }
}

resource "aws_s3_bucket" "noteapp_frontend" {
  bucket        = "noteapp-frontend-bucket"
  force_destroy = true

  tags = {
    Name = "NoteApp Frontend side"
  }
}

resource "aws_s3_bucket_ownership_controls" "frontend_ownership" {
  bucket = aws_s3_bucket.noteapp_frontend.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "frontend_public_access" {
  bucket = aws_s3_bucket.noteapp_frontend.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_object" "noteapp_frontend_files" {
  for_each = local.frontend_files
  bucket       = aws_s3_bucket.noteapp_frontend.bucket
  key          = each.key
  source       = "app/${each.key}"
  content_type = each.value

  #Review
  source_hash  = filemd5("app/${each.key}")
}
