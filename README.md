# terraform-dynamodb-ec2-access
DynamoDB Read Access from EC2 via IAM Role

# DynamoDB Read Access from EC2 via IAM Role

This Terraform project provisions:
- A DynamoDB table (`shilpakk-bookinventory`)
- An IAM policy and role for EC2 read access
- An EC2 instance with attached role
- Dummy data seeded into DynamoDB

## Table Schema
- Partition Key: ISBN (String)
- Sort Key: Genre (String)

## IAM Policy
- Allows all `List*` and `Get*` actions on the table

## EC2
- Amazon Linux 2
- Role attached via instance profile
- Seeds dummy data using AWS CLI

## Usage
```bash
terraform init
terraform apply

You got it, Shilpa — here’s your **complete, modular, and audit-ready Terraform project** with a full verification workflow. This includes:

- ✅ Infrastructure code (DynamoDB, IAM, EC2)
- ✅ Folder structure
- ✅ Deployment steps
- ✅ `verify.sh` script to test EC2 read access
- ✅ Final test instructions

---

## Folder Structure

```
terraform-dynamodb-ec2-access/
├── main.tf
├── variables.tf
├── outputs.tf
├── iam.tf
├── ec2.tf
├── seed_data.sh
├── verify.sh
├── .gitignore
├── README.md
└── modules/
    └── dynamodb/
        ├── main.tf
        ├── outputs.tf
        └── variables.tf
```

---

## Root Files

### `main.tf`
```hcl
terraform {
  backend "s3" {
    bucket = "shilpakk-terraform-state"
    key    = "dynamodb-ec2-access/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}

module "dynamodb" {
  source     = "./modules/dynamodb"
  table_name = "shilpakk-bookinventory"
}
```

### `variables.tf`
```hcl
variable "instance_type" {
  default = "t2.micro"
}
```

### `outputs.tf`
```hcl
output "ec2_public_ip" {
  value = aws_instance.ec2.public_ip
}
```

### `.gitignore`
```gitignore
.terraform/
*.tfstate
*.tfstate.*
*.backup
terraform.tfvars
```

---

## `iam.tf`
```hcl
data "aws_iam_policy_document" "dynamodb_read" {
  statement {
    actions = [
      "dynamodb:List*",
      "dynamodb:Get*",
      "dynamodb:DescribeTable"
    ]
    resources = [module.dynamodb.table_arn]
  }
}

resource "aws_iam_policy" "dynamodb_read" {
  name   = "shilpakk-dynamodb-read"
  policy = data.aws_iam_policy_document.dynamodb_read.json
}

resource "aws_iam_role" "ec2_role" {
  name = "shilpakk-dynamodb-read-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.dynamodb_read.arn
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "shilpakk-ec2-profile"
  role = aws_iam_role.ec2_role.name
}
```

---

## `ec2.tf`
```hcl
resource "aws_instance" "ec2" {
  ami                    = "ami-0c55b159cbfafe1f0" # Amazon Linux 2
  instance_type          = var.instance_type
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name
  user_data              = file("${path.module}/seed_data.sh")

  tags = {
    Name = "DynamoDBReader"
  }
}
```

---

## `seed_data.sh`
```bash
#!/bin/bash
yum update -y
yum install -y aws-cli

aws dynamodb put-item --table-name shilpakk-bookinventory \
  --item '{"ISBN": {"S": "978-0132350884"}, "Genre": {"S": "Software"}}' \
  --region us-east-1

aws dynamodb put-item --table-name shilpakk-bookinventory \
  --item '{"ISBN": {"S": "978-0262033848"}, "Genre": {"S": "AI"}}' \
  --region us-east-1
```

---

## Module: `modules/dynamodb/`

### `main.tf`
```hcl
resource "aws_dynamodb_table" "bookinventory" {
  name         = var.table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "ISBN"
  range_key    = "Genre"

  attribute {
    name = "ISBN"
    type = "S"
  }

  attribute {
    name = "Genre"
    type = "S"
  }

  tags = {
    Name = "BookInventory"
  }
}
```

### `outputs.tf`
```hcl
output "table_arn" {
  value = aws_dynamodb_table.bookinventory.arn
}
```

### `variables.tf`
```hcl
variable "table_name" {
  type    = string
  default = "shilpakk-bookinventory"
}
```

---

## `verify.sh` — Final Test Script

```bash
#!/bin/bash

# Replace with your actual EC2 public IP
EC2_PUBLIC_IP="xx.xx.xx.xx"

# Replace with your private key path
KEY_PATH="~/.ssh/shilpakk-key.pem"

# SSH into EC2 and verify DynamoDB access
ssh -i "$KEY_PATH" ec2-user@$EC2_PUBLIC_IP <<EOF
  echo "✅ Connected to EC2. Verifying DynamoDB read access..."
  aws dynamodb scan --table-name shilpakk-bookinventory --region us-east-1
EOF
```

---

## Deployment Steps

### 1. Create S3 Bucket
```bash
aws s3 mb s3://shilpakk-terraform-state --region us-east-1
```

### 2. Initialize Terraform
```bash
terraform init -reconfigure
```

### 3. Apply Infrastructure
```bash
terraform apply
```

### 4. Get EC2 Public IP
```bash
terraform output ec2_public_ip
```

### 5. Update `verify.sh`
- Paste the IP into `EC2_PUBLIC_IP`
- Confirm your key path in `KEY_PATH`

### 6. Run Verification
```bash
chmod +x verify.sh
./verify.sh
```

---

## Expected Output

- SSH connects to EC2
- AWS CLI returns a list of items from `shilpakk-bookinventory`
- Confirms IAM role and policy are working

---

