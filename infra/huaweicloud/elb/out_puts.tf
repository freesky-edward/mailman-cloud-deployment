output "this_elb_ids" {
  description = "List of IDs of the elbs"
  value       = "${join(",",huaweicloud_elb_loadbalancer.this.*.id)}"
}

