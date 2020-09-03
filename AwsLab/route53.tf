resource "aws_route53_zone" "zied-lab" {
  name = "zied.lab"
}

resource "aws_route53_record" "server1-record" {
  zone_id = aws_route53_zone.zied-lab.zone_id
  name    = "server1.zied.lab"
  type    = "A"
  ttl     = "300"
  records = ["35.180.108.56"]
}

resource "aws_route53_record" "www-record" {
  zone_id = aws_route53_zone.zied-lab.zone_id
  name    = "www.zied.lab"
  type    = "A"
  ttl     = "300"
  records = ["35.180.108.56"]
}



output "ns-servers" {
  value = aws_route53_zone.zied-lab.name_servers
}