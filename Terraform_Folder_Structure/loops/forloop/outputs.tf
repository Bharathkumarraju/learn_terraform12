output "upper_names" {
  value = [for name in var.names: upper(name) if length(name) <= 7 ]
}

output "bios" {
  value = [for name, role in var.hero_thousand_faces : "${name} is the ${role}"]
}

output "upper_roles" {
  value = {for name, role in var.hero_thousand_faces: upper(name) => upper(role)}
}

output "for_string_directive" {
  value = <<EOF
  %{~ for name in var.bknames } ${name}
  %{~ endfor }
  EOF
}