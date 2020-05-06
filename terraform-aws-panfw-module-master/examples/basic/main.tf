provider "aws" {
  region = "eu-north-1"
}

module "vpc" {
  source     = "git::https://gitlab.com/public-tf-modules/terraform-aws-vpc?ref=v0.1.0"
  cidr_block = "10.0.0.0/16"
  subnets = {
    public-1a  = { cidr = "10.0.0.0/24", az = "eu-north-1a", route_table = "public" },
    public-1b  = { cidr = "10.0.1.0/24", az = "eu-north-1b", route_table = "public" },
    private-1a = { cidr = "10.0.8.0/24", az = "eu-north-1a", route_table = "tgw" },
    private-1b = { cidr = "10.0.99.0/24", az = "eu-north-1b", route_table = "private" }
    tgw-1a     = { cidr = "10.0.18.0/24", az = "eu-north-1a", route_table = "tgw" },
    tgw-1b     = { cidr = "10.0.19.0/24", az = "eu-north-1b", route_table = "tgw" },
    mgmt-1a    = { cidr = "10.0.10.0/24", az = "eu-north-1a", route_table = "mgmt" },
    mgmt-1b    = { cidr = "10.0.11.0/24", az = "eu-north-1b", route_table = "mgmt" },
  }
  public_rts = ["public"]
}

module "firewall" {
  source = "../../"
  fw_name = "test"
  fw_key_name = "TD-24JAN20"
  subnet_id = module.vpc.subnets["mgmt-1a"].id 
  interfaces = {
    public = {
      subnet_id = module.vpc.subnets["public-1a"].id 
      index = 1
      source_dest_check = false
      public_ip = "yes"
    },
    private = {
      subnet_id = module.vpc.subnets["private-1a"].id 
      index = 2
      source_dest_check = false
    }  
  }
}
