variable "ami" {
  default = "ami-0c7217cdde317cfec"  # Ubuntu AMI for us-east-1 (check region specific AMIs)
}

variable "instance_type" {
  default = "t2.micro"
}
