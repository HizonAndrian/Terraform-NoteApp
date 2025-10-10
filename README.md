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

* ordered_cache_behavior 
Requests like /api/notes, /api/users → handled by ordered behavior, forwarded to your ALB, not cached.