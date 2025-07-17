output "east_public_ip" {
  value = aws_instance.east_instance.public_ip
}

output "south_public_ip" {
  value = aws_instance.south_instance.public_ip
}
