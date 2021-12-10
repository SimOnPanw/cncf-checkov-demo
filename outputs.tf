output "nat_gateway_ips_vpc1_az1" {
  value       = aws_eip.vpc1_nat_az1.public_ip
  description = "Public IP of Nat Gateway in VPC1 AZ1"
}
output "nat_gateway_ips_vpc1_az2" {
  value       = aws_eip.vpc1_nat_az2.public_ip
  description = "Public IP of Nat Gateway in VPC1 AZ2"
}