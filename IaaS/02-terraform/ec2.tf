resource "aws_instance" "app_server" {
  ami                    = "ami-08ec94f928cf25a9d" # Amazon Linux 2 AMI
  instance_type          = "t2.micro"
  subnet_id              = data.aws_subnet.first_subnet.id
  iam_instance_profile   = aws_iam_instance_profile.ec2_instance_profile.name
  vpc_security_group_ids = [aws_security_group.allow_ssh_http.id]

# TODO: feature (automatically startup the service)
#   user_data = templatefile("userdata.sh", {
#     "tableName" : aws_dynamodb_table.demo_table.name
#   })
  key_name = "unifi-test" # Specify the existing key pair

  tags = {
    Name = "${local.resource_prefix}iaas-ec2"
  }
}
