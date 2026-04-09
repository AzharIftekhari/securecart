output "vpc_id" {
  description = "ID of the VPC."
  value       = aws_vpc.secure-vpc.id
}

output "vpc_cidr" {
  description = "CIDR block of the VPC."
  value       = aws_vpc.secure-vpc.cidr_block
}

output "public_subnet_1_id" {
  description = "ID of public subnet in AZ-1."
  value       = aws_subnet.public_1.id
}

output "public_subnet_2_id" {
  description = "ID of public subnet in AZ-2."
  value       = aws_subnet.public_2.id
}

output "private_subnet_1_id" {
  description = "ID of private subnet in AZ-1."
  value       = aws_subnet.private_1.id
}

output "private_subnet_2_id" {
  description = "ID of private subnet in AZ-2."
  value       = aws_subnet.private_2.id
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway."
  value       = aws_internet_gateway.secure-igw.id
}

output "nat_gateway_id" {
  description = "ID of the NAT Gateway."
  value       = aws_nat_gateway.secure-nat.id
}

output "nat_eip_public_ip" {
  description = "Public IP of the NAT Gateway Elastic IP."
  value       = aws_eip.nat.public_ip
}

output "public_route_table_id" {
  description = "ID of the public route table."
  value       = aws_route_table.public.id
}

output "private_route_table_id" {
  description = "ID of the private route table."
  value       = aws_route_table.private.id
}
