resource "aws_instance" "ec2" {
  ami           = "ami-052064a798f08f0d3" # Amazon Linux 2 (update as needed)
  instance_type = var.instance_type
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  user_data = file("${path.module}/seed_data.sh")

  tags = {
    Name = "DynamoDBReader"
  }
}