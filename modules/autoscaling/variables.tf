variable "ami_id" {
  type        = string
  description = "AMI ID for EC2 instances"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs for Load Balancer and ASG"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "key_name" {
  type        = string
  description = "Name of the key pair"
}

variable "security_group_id" {
  type        = string
  description = "Security group ID"
}

variable "env" {
  type        = string
  description = "Environment name"
}
