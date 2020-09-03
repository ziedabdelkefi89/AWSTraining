variable "AWS_REGION" {
  default = "eu-west-3"
}

variable "PATH_TO_PRIVATE_KEY" {
  default = "MyKeyPair.pem"
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "MyKeyPair.pub"
}

variable "AMIS" {
  default = "ami-066379f675d5036e7"
}

variable "INSTANCE_DEVICE_NAME" {
  default = "/dev/xvdh"
}


variable "RDS_PASSWORD" {
  default= "ZiedAbdelkef1"
}