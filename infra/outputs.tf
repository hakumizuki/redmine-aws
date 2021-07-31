output "app_endpoint" {
  value = aws_route53_record.app.fqdn
}

output "ec2-pdns-1" {
  value = aws_instance.redmine.public_dns
}

output "ec2-pdns-2" {
  value = aws_instance.redmine-2.public_dns
}

output "db_address" {
  value = aws_db_instance.main.address
}
