# Using the count feature can simplify your Terraform code when you need to create multiple instances of the same resource with similar configuration.

resource "aws_instance" "web_server" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  count         = 3

  tags = {
    Name = "Web Server ${count.index + 1}"
  }
}

resource "aws_security_group" "web_server_sg" {
  name_prefix = "web_server_sg-"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  count = 3

  tags = {
    Name = "Web Server Security Group ${count.index + 1}"
  }
}

# In this example, we're creating three AWS EC2 instances and three security groups. 
# The count parameter specifies how many instances and security groups to create. 
# The tags block sets the name of each resource with a unique name based on the index of the resource being created.
# The aws_instance resource block creates three instances of type t2.micro and uses the Amazon Machine Image (AMI) ami-0c55b159cbfafe1f0. 
# The aws_security_group resource block creates three security groups with inbound rules for port 80 and 22 and an outbound rule for all traffic. 
# The name_prefix parameter ensures that each security group has a unique name.