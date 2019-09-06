module "network" {
  source ="./network/"

  // VPC
  name = "net-mailman"
  cidr = "172.16.0.0/16"

  // VPC Subnet
  subnets = [
    {
      name       = "subnet-mailman"
      cidr       = "172.16.1.0/24"
      gateway_ip = "172.16.1.1"
    }
  ]
}


module "cce" {
  source = "./cce"
 
  name   = "cce-mailman"
  description = "This is cce cluster for mailman"
  vpc_id = "${module.network.this_vpc_id}"
  subnet_id = "${split(",", module.network.this_network_ids)[0]}"
  flavor_id = "cce.s1.large"

  nodes = [
    {
      name    = "node1",
      ssh_key = "${var.keypair}",
      az      = "${var.az}",
      flavor_id = "${var.node_flavor}"
    }
  ]  
}

module "internet" {
  source = "./internet"
  
  eips = [
    {
      bandwidth-name = "bandwidth-01",
      size           = "5"
    },
    {
      bandwidth-name = "bandwidth-02",
      size           = "5"
    },
    {
      bandwidth-name = "bandwidth-03",
      size           = "5"
    } 
  ]
}

module "nat" {
  source = "./nat"

  name = "nat-cluster"
  description = "this is a nat gateway to provide the access to internet for node"
  spec_code = 3
  router_id = "${module.network.this_vpc_id}"
  network_id = "${split(",", module.network.this_network_ids)[0]}"

  rules = [
    {
      network_id = "${split(",", module.network.this_network_ids)[0]}"
      eip_id = "${split(",",module.internet.this_eip_ids)[0]}"
    }
  ]
}


module "elb" {
  source = "./elb"
  
  loadbalancers = [
    {
      name  =  "elb-web"
      description = "The load balancer of mailman-web"
      type = "External"
      vpc_id = "${module.network.this_vpc_id}"
      eip    = "${split(",", module.internet.this_eip_addresses)[1]}"
    },
    {
      name  =  "elb-mta"
      description = "The load balancer of mail MTA"
      type = "External"
      vpc_id = "${module.network.this_vpc_id}"
      eip    = "${split(",", module.internet.this_eip_addresses)[2]}"
    }
  ]
}
  
 
module "dns" {
  source = "./dns"
  
  domain = "${var.domain}."
  email  = "${var.email}"
  
  records = [
    {
      domain = "${var.sub_domain_mail}.${var.domain}."
      type  =  "A"
      value = "${split(",", module.internet.this_eip_addresses)[2]}"
    },
    {
      domain = "${var.sub_domain_web}.${var.domain}."
      type = "A"
      value = "${split(",", module.internet.this_eip_addresses)[1]}"
    },
    {
      domain = "${var.domain}."
      type = "MX"
      value = "1 ${var.sub_domain_mail}.${var.domain}."
    },
    {
      domain = "${var.domain}."
      type = "TXT"
      value = "\"v=spf1 a mx ip4:${split(",", module.internet.this_eip_addresses)[0]}  ~all\""
    },
    {
      domain = "_dmarc.${var.domain}."
      type = "TXT"
      value = "\"v=DMARC1;p=reject;sp=reject;adkim=r;aspf=r;fo=1;rf=afrf;pct=100;ruf=mailto:${var.email};ri=86400\""
    },
    {
      domain = "${var.selector}._domainkey.${var.domain}."
      type = "TXT"
      value = "\"v=DKIM1;k=rsa;p=${var.dkim_public_key}\""
    }
  ]

  ptrs = [
    {
       domain = "${var.domain}."
       ip     = "${split(",", module.internet.this_eip_ids)[0]}"
    }
  ]
} 
