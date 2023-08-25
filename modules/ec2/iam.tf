resource "aws_ssm_activation" "ec2" {
  name               = "${var.instance_name}-ssm-activation"
  iam_role           = aws_iam_role.ec2.id
  description        = "EC2 SSM activation"
  registration_limit = 1
}

# Attach AmazonSSMManagedInstanceCore policy to the IAM role
resource "aws_iam_role_policy_attachment" "ec2_role_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.ec2.name
}

resource "aws_iam_role" "ec2" {
  name = "${var.instance_name}-ec2-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = [
            "ssm.amazonaws.com",
            "ec2.amazonaws.com"
          ]
        }
      }
    ]
  })
}

resource "aws_iam_instance_profile" "ec2" {
  name = "${var.instance_name}-ec2-ssm-instance-profile"

  role = aws_iam_role.ec2.name
}
