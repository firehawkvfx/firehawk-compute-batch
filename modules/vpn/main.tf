variable "vpc_id" {
}

variable "vpc_cidr" {
}

variable "vpn_cidr" {
}

variable "bastion_ip" {
}

# remote_vpn_ip_cidr is the ip address of the remote host / user intending to connect over vpn. eg '197.125.62.53/32'
variable "remote_vpn_ip_cidr" {
}

# examples ["subnet-0a7554f56af4d6d0a", "subnet-0257c7f8b1d68b6e4"]
variable "public_subnet_ids" {
  default = []
}

variable "route_zone_id" {
}

variable "aws_key_name" {
}

#contents of the my_key.pem file to connect to the vpn.
variable "private_key" {
}

variable "instance_type" {
  default = "t3.micro"
}

variable "cert_arn" {
}

# public domain name withou www
variable "public_domain_name" {
}

variable "openvpn_admin_user" {
}

variable "openvpn_user" {
}

variable "openvpn_user_pw" {
}

variable "openvpn_admin_pw" {
}

variable "aws_private_key_path" {
}

variable "sleep" {
  default = false
}

variable "remote_subnet_cidr" {
}

variable "igw_id" {
}

variable "private_subnets" {
  default = []
}

variable "public_subnets" {
  default = []
}

variable "route_public_domain_name" {}

variable "create_vpn" {}

variable "aws_region" {}

variable "bastion_dependency" {}

variable "private_route_table_ids" {}
variable "public_route_table_ids" {}
variable "common_tags" {}

variable "firehawk_init_dependency" {}
variable "private_domain_name" {}

module "openvpn" {
  #source = "github.com/firehawkvfx/tf_aws_openvpn"

  create_vpn = var.create_vpn

  source = "../tf_aws_openvpn"

  route_public_domain_name = var.route_public_domain_name

  #start vpn will initialise service locally to connect
  #start_vpn = false
  igw_id = var.igw_id

  #create_openvpn = "${var.create_openvpn}"
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

  name = "openvpn_ec2_pipeid${lookup(var.common_tags, "pipelineid", "0")}"

  private_domain_name = var.private_domain_name

  # VPC Inputs
  vpc_id             = var.vpc_id
  vpc_cidr           = var.vpc_cidr
  vpn_cidr           = var.vpn_cidr
  public_subnet_ids  = var.public_subnet_ids
  remote_vpn_ip_cidr = var.remote_vpn_ip_cidr
  remote_subnet_cidr = var.remote_subnet_cidr

  private_route_table_ids = var.private_route_table_ids
  public_route_table_ids = var.public_route_table_ids

  # EC2 Inputs
  aws_key_name       = var.aws_key_name
  private_key    = var.private_key
  aws_private_key_path = var.aws_private_key_path
  instance_type  = var.instance_type

  # Network Routing Inputs.  source destination checks are disable for nat gateways or routing on an instance.
  source_dest_check = false

  # ELB Inputs
  cert_arn = var.cert_arn

  # DNS Inputs
  public_domain_name = var.public_domain_name
  route_zone_id      = var.route_zone_id

  # OpenVPN Inputs
  openvpn_user       = var.openvpn_user
  openvpn_user_pw    = var.openvpn_user_pw
  openvpn_admin_user = var.openvpn_admin_user # Note: Don't choose "admin" username. Looks like it's already reserved.
  openvpn_admin_pw   = var.openvpn_admin_pw

  bastion_ip = var.bastion_ip
  bastion_dependency = var.bastion_dependency
  firehawk_init_dependency = var.firehawk_init_dependency

  #sleep will stop instances to save cost during idle time.
  sleep = var.sleep

  common_tags = var.common_tags
}

output "id" {
  value = module.openvpn.id
}

output "private_ip" {
  value = module.openvpn.private_ip
}

output "public_ip" {
  value = module.openvpn.public_ip
}

