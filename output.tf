

output "enabled" {
  value       = local.enabled
  description = "True if module is enabled, false otherwise"
}

output "namespace" {
  value       = local.enabled ? local.namespace : ""
  description = "Normalized namespace"
}

output "tenant" {
  value       = local.enabled ? local.tenant : ""
  description = "Normalized tenant"
}

output "environment" {
  value       = local.enabled ? local.environment : ""
  description = "Normalized environment"
}

output "name" {
  value       = local.enabled ? local.name : ""
  description = "Normalized name"
}

output "stage" {
  value       = local.enabled ? local.stage : ""
  description = "Normalized stage"
}

output "delimiter" {
  value       = local.enabled ? local.delimiter : ""
  description = "Delimiter between `namespace`, `tenant`, `environment`, `stage`, `name` and `attributes`"
}

output "tags" {
  value       = local.enabled ? local.tags : {}
  description = "Normalized Tag map"
}
output "label_order" {
  value       = local.label_order
  description = "The naming order actually used to create the ID"
}

output "regex_replace_chars" {
  value       = local.regex_replace_chars
  description = "The regex_replace_chars actually used to create the ID"
}



output "normalized_context" {
  value       = local.output_context
  description = "Normalized context of this module"
}

output "context" {
  value       = local.input
  description = <<-EOT
  Merged but otherwise unmodified input to this module, to be used as context input to other modules.
  Note: this version will have null values as defaults, not the values actually used as defaults.
EOT
}