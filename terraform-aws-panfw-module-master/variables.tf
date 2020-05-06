variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}

variable "fw_key_name" {
  description = "SSH Public Key to use w/firewall"
  default     = ""
}

# Firewall version for AMI lookup

variable "fw_version" {
  description = "Select which FW version to deploy"
  default     = "9.0.5"
  # Acceptable Values Below
}

# License type for AMI lookup
variable "fw_license_type" {
  description = "Select License type (byol/payg1/payg2)"
  default     = "byol"
}

# Product code map based on license type for ami filter

variable "fw_license_type_map" {
  type = map(string)
  default = {
    "byol"  = "6njl1pau431dv1qxipg63mvah"
    "payg1" = "6kxdw3bbmdeda3o6i1ggqt4km"
    "payg2" = "806j2of0qy5osgjjixq9gqc6g"
  }
}

variable "fw_instance_type" {
  description = "EC2 Instance Type"
  type        = string
  default     = "m5.xlarge"
}


variable "interfaces" {
  description = "Map of interfaces"
}  

variable "public_ip" {
  description = "specify if you should have pubilc ip on launch"
  type = bool
  default = false
}

variable "subnet_id" {
  description = "Subnet to launch firewall in "
  type = string
}

variable "fw_name" {
  description = "Name of the firewall"
  type = string
}

