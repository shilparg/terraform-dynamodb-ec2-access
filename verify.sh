#!/bin/bash

EC2_PUBLIC_IP="3.239.249.48"
KEY_PATH="~/.ssh/shilpakk-key.pem"

ssh -i "$KEY_PATH" -o StrictHostKeyChecking=no -t ec2-user@$EC2_PUBLIC_IP <<EOF
  echo "✅ Connected to EC2. Verifying DynamoDB read access..."
  aws dynamodb scan --table-name shilpakk-bookinventory --region us-east-1
EOF