output "upper_names" {
  value = [for name in var.names: upper(name) if length(name) <= 7 ]
}

output "bios" {
  value = [for name, role in var.hero_thousand_faces : "${name} is the ${role}"]
}