locals {
  frontend_files = ["index.html", "script.js", "style.css"]
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
  for_each = toset(local.frontend_files)
  bucket   = aws_s3_bucket.noteapp_frontend.id
  key      = each.value
  source   = "app/${each.value}"

  # REVIEW!
  etag = filemd5("app/${each.value}")

}