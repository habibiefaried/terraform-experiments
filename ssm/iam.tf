resource "aws_ssm_activation" "ec2" {
  name               = "ssm-activation"
  iam_role           = aws_iam_role.ec2.arn
  description        = "EC2 SSM activation"
  registration_limit = 1 # Adjust this as needed
}

resource "aws_iam_role" "ec2" {
  name = "ec2-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ssm.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_instance_profile" "ec2" {
  name = "ec2-ssm-instance-profile"

  role = aws_iam_role.ec2.id
}
