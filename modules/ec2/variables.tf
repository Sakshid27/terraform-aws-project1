variable "instance_type" {
  description = "Type of EC2 instance to launch"
  type        = string
}

variable "subnet_id" {
  description = "The subnet ID where the instance will be launched"
  type        = string
}

variable "key_name" {
  description = "The name of the key pair to use for SSH"
  type        = string
}

variable "env" {
  description = "Environment name (workspace)"
  type        = string
}
