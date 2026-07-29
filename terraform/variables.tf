variable "domain_name" {
  description = "Fully qualified domain for the site"
  type        = string
  default     = "timetracker.am3e.dev"
}

variable "zone_name" {
  description = "Route 53 hosted zone the domain lives in"
  type        = string
  default     = "am3e.dev"
}
