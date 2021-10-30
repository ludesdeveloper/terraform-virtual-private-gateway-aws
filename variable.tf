variable "access_key" {}
variable "secret_key" {}
variable "region" {
  default = "ap-southeast-2"
}
variable "public_key_file" {
  type    = string
  default = "./ec2-for-development.pub"
}
