variable "region" {
  type    = string
  default = "eu-west-1"
}

variable "tenant" {
  type        = string
  description = "NECS Tenant number"
  default     = "32803"
}

variable "environment" {
  type        = string
  description = "Name of environment this VPC is targeting"
  default     = "DEV"
}

variable "az1" {
  type    = string
  default = "eu-west-1b"
}

variable "az2" {
  type    = string
  default = "eu-west-1c"
}


###########
## VPC1
##########

variable "cidr_blocks_vpc1" {
  type        = string
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/20"
}
variable "public_subnet_cidr_blocks_vpc1_az1" {
  type    = string
  default = "10.0.0.0/24"
}

variable "public_subnet_cidr_blocks_vpc1_az2" {
  type    = string
  default = "10.0.1.0/24"
}

variable "private_subnet_cidr_blocks_vpc1_az1" {
  type    = string
  default = "10.0.2.0/24"
}

variable "private_subnet_cidr_blocks_vpc1_az2" {
  type    = string
  default = "10.0.3.0/24"
}
