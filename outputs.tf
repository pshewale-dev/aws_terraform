output "ansible_node_public_ip" {
  value = aws_instance.ansible_node.public_ip
}

output "ansible_host1_public_ip" {
  value = aws_instance.ansible_host1.public_ip
}

output "ansible_host2_public_ip" {
  value = aws_instance.ansible_host2.public_ip
}

