output "cce_clusters" {
    value = "${module.cce.clusters}"
}

output "cce_users" {
    value = "${module.cce.users}"
}

output "exim4_elb_id" {
    value = "${split(",", module.elb.this_elb_ids)[1]}"
}

output "web_elb_id"  {
    value = "${split(",", module.elb.this_elb_ids)[0]}"
}

output "exim4_eip" {
    value = "${split(",", module.internet.this_eip_addresses)[2]}"
}

output "web_eip" {
    value = "${split(",", module.internet.this_eip_addresses)[1]}"
}


output "exim4_domain" {
    value = "${var.sub_domain_mail}.${var.domain}"
}

output "web_domain" {
    value = "${var.sub_domain_web}.${var.domain}"
}

output "dkim_selector" {
   value = "${var.selector}"
}

