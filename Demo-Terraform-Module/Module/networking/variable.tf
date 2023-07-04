variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "vpc_tags" {
#  default     = {}
  description = "Additional resource tags"
  type        = map(string)
  default = {
    "Name" = "Vpc-dev"
  }
}

variable "pub_cidrs" {
  description = "Public CIDR value"
  default     = ["10.0.0.0/24", "10.0.1.0/24"]
}
variable "pri_cidrs" {
  description = "Private CIDR value"
  default     = ["10.0.2.0/24", "10.0.3.0/24"]
}
