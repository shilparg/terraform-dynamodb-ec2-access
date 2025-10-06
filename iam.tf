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