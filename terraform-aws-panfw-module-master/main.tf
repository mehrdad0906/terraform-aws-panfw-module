locals {
  eips = {for name, eip in var.interfaces : name => eip if contains(keys(eip), "public_ip")}
}
#### PA VM AMI ID Lookup based on license type, region, version ####

data "aws_ami" "pa-vm" {
  most_recent = true
  owners      = ["aws-marketplace"]

  filter {
    name = "product-code"
    values = [var.fw_license_type_map[var.fw_license_type]]
  }


  filter {
    name   = "name"
    values = ["PA-VM-AWS-${var.fw_version}*"]
  }
}

#### Create the Firewall Instances ####

resource "aws_instance" "this" {
  disable_api_termination              = false
  instance_initiated_shutdown_behavior = "stop"
  ebs_optimized                        = true
  ami                                  = data.aws_ami.pa-vm.id
  instance_type                        = var.fw_instance_type
  subnet_id = var.subnet_id
  associate_public_ip_address = var.public_ip
  #user_data = var.user_data
  tags = merge(
    {
      "Name" = format("%s", var.fw_name)
    }
  )

  root_block_device {
    delete_on_termination = true
  }

  key_name   =  var.fw_key_name
  monitoring = false
}

resource "aws_network_interface" "this" {
  for_each = var.interfaces
  subnet_id       = each.value.subnet_id
  private_ips     = lookup(each.value, "private_ips", null)
  security_groups = lookup(each.value, "security_groups", null) 
  source_dest_check = lookup(each.value, "source_dest_check", null)
  attachment {
    instance     = aws_instance.this.id
    device_index = lookup(each.value, "index", null)
  }
  tags = merge(var.tags, lookup(each.value, "tags", {}), {"Name" = each.key})
}

resource "aws_eip" "this" {
  for_each = local.eips
  vpc      = true
  network_interface = aws_network_interface.this[each.key].id
  tags = merge(var.tags,  {"Name" = each.key})
}
