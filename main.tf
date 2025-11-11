provider "aws" {
  region = "ap-south-1"
}

# Fetch AMI dynamically
data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}

module "vpc" {
  source             = "./modules/vpc"
  vpc_cidr           = "10.0.0.0/16"
  public_subnet_cidr = "10.0.1.0/24"
  az                 = "ap-south-1a"
  env                = terraform.workspace
}

module "ec2" {
  source        = "./modules/ec2"
  instance_type = "t2.micro"
  subnet_id     = module.vpc.subnet_id
  key_name      = "terraform-key"
  env           = terraform.workspace
}

module "autoscaling" {
  source            = "./modules/autoscaling"
  ami_id            = data.aws_ami.amazon_linux.id
  subnet_ids        = [module.vpc.subnet_id, module.vpc.subnet_id_2]  # use both subnets
  vpc_id            = module.vpc.vpc_id
  key_name          = "terraform-key"
  security_group_id = "sg-0eeac2c0f8232d95c"
  env               = terraform.workspace
}


output "instance_id" {
  value = module.ec2.instance_id
}

output "load_balancer_dns" {
  value = module.autoscaling.load_balancer_dns
}
