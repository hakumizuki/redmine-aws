variable "prefix" {
  type        = string
  default     = "rdmaws"
  description = "Prefix that will be used for naming resources. Stands for redmine-aws"
}

variable "project" {
  default = "redmine-aws"
}

variable "dns_zone_name" {
  description = "Domain name"
  default     = "youthpod.org"
}
