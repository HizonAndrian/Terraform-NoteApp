# Terraform-NoteApp
A full-stack notes application built using Docker containers and deployed on AWS using ECS and Terraform. 
Designed to demonstrate scalable microservice architecture, DevOps practices, and secure VPC networking.

📐 Architecture
1. Frontend (HTML, CSS, Javascript)
2. Backend API (Fast API)
3. MongoDB (persistent data)
4. EFS volume
5. Load Balancer
6. Private/Public subnets
7. ECS / EKS deployment


## 🧠 Tech Stack
**Infrastructure & IaC**
- Terraform, Terraform Cloud
- AWS VPC, ECS, ECR, EFS
- AWS IAM (roles & policies)
- AWS Systems Manager (SSM Parameters for secrets & config)

**Networking & Security**
- Security Groups, NAT Gateway, Route Tables
- AWS Route 53 (custom domain)
- AWS CloudFront (CDN + HTTPS)
- AWS Certificate Manager (ACM TLS)

**Storage & Data**
- Amazon S3 (static assets, backups)
- MongoDB (containerized with persistent EFS volume)

**Application Components**
- Backend API (Python FastAPI)
- Frontend (HTML, CSS, Javascript)

**Deployment & Monitoring**
- Terraform Cloud (remote backend)
- AWS CloudWatch (logging & metrics)
- ECS Task Definitions + Load Balancer (ALB)


## 🏗️ Deployment Flow

1. **Build and Tag Application Images**
   - Build Docker images for the **backend** services.
   - Use the official **MongoDB** image from Docker Hub (no custom build).
   - Tag and push your own images to **Amazon ECR**.

2. **Provision Infrastructure**
   - Deploy AWS resources using **Terraform**:
     - VPC, subnets, NAT gateway, and route tables.
     - Security Groups for each component (ALB, backend, MongoDB, EFS).
     - ECS Cluster and Task Definitions.
     - S3 bucket for static website assets or media files.
     - CloudFront distribution for global CDN delivery.
     - Route 53 record pointing to CloudFront or ALB.
     - SSM Parameters for storing secrets (e.g., DB credentials, API keys).

3. **Deploy Application**
   - ECS Tasks automatically pull container images from **ECR**.
   - ALB routes HTTPS traffic (via **ACM certificate**) to the backend service.
   - Frontend connects securely to backend API through private networking.

4. **Access Application**
   - Application is available through a custom domain managed in **Route 53**.
   - Static assets are served from **CloudFront** + **S3** for high availability and low latency.

5. **Monitor and Maintain**
   - **CloudWatch** monitors logs, ECS metrics, and service health.
   - **SSM Parameter Store** allows secure updates to environment variables without redeploying.






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


