# Terraform-NoteApp

# First command to run:
 - terraform apply -target="aws_ecr_repository.noteapp_ecr"


 Locals and Local

 Client (Browser)
   ↓  HTTPS :443
Application Load Balancer
   ↓  Listener (port 443)
   ↓  Forward
Target Group (port 8000)
   ↓
ECS Task (container: backend, port 8000)
   ↓
ECS Task (container: mongodb, port 27017)

* static vs dynamin

* TTL

* default_cache_behavior 
Requests like /index.html, /style.css, etc. → handled by default behavior, cached from S3. 


{
    "Version": "2008-10-17",
    "Id": "PolicyForCloudFrontPrivateContent",
    "Statement": [
        {
            "Sid": "AllowCloudFrontServicePrincipal",
            "Effect": "Allow",
            "Principal": {
                "Service": "cloudfront.amazonaws.com"
            },
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::noteapp-frontend-buckets/*",
            "Condition": {
                "StringEquals": {
                    "AWS:SourceArn": "arn:aws:cloudfront::686797372394:distribution/E35P1C6LFWN00"
                }
            }
        }
    ]
}


