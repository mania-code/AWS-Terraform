variable "instance_type" {
  default = "t2.micro"
  type = string
}

variable "image_id" {
  default = "ami-0e35ddab05955cf57"
  type = string
}

variable "root_block_size" {
  default = 10
  type = number
}