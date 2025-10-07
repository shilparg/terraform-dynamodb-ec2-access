resource "aws_instance" "ec2" {
  ami                         = "ami-052064a798f08f0d3" #"ami-0c55b159cbfafe1f0"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.main.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name
  key_name                    = "shilpakk-key"
  user_data                   = file("${path.module}/seed_data.sh")

  tags = {
    Name = "DynamoDBReader"
  }
}