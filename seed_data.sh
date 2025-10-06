#!/bin/bash
yum update -y
yum install -y aws-cli

aws dynamodb put-item --table-name shilpakk-bookinventory \
  --item '{"ISBN": {"S": "978-0132350884"}, "Genre": {"S": "Software"}}' \
  --region ap-southeast-1

aws dynamodb put-item --table-name shilpakk-bookinventory \
  --item '{"ISBN": {"S": "978-0262033848"}, "Genre": {"S": "AI"}}' \
  --region ap-southeast-1