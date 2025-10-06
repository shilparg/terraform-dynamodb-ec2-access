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
