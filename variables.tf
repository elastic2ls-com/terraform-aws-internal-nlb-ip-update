variable "stage" {
  type = string
}

variable "main_region" {
  type    = string
  default = "eu-central-1"
}

variable "alb_description_name" {
  type = string
}

variable "zone_id" {
  type = string
}

variable "intra_dns_name" {
  type = string
} 

variable "nlb_tg_arn" {
  type = string
}