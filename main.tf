locals {

  defaults = {
    label_order         = ["namespace", "environment", "stage", "name"]
    regex_replace_chars = "/[^-a-zA-Z0-9]/"
    delimiter           = "-"
    replacement         = ""
    id_length_limit     = 0
    label_key_case      = "title"
    label_value_case    = "lower"
  }

  replacement    = local.defaults.replacement

  input = {
    enabled   = var.enabled == null ? var.context.enabled : var.enabled
    namespace = var.namespace == null ? var.context.namespace : var.namespace
    tenant      = var.tenant == null ? lookup(var.context, "tenant", null) : var.tenant
    environment = var.environment == null ? var.context.environment : var.environment
    stage       = var.stage == null ? var.context.stage : var.stage
    name        = var.name == null ? var.context.name : var.name
    delimiter   = var.delimiter == null ? var.context.delimiter : var.delimiter
    tags       = merge(var.context.tags, var.tags)

    label_order         = var.label_order == null ? var.context.label_order : var.label_order
    regex_replace_chars = var.regex_replace_chars == null ? var.context.regex_replace_chars : var.regex_replace_chars
    id_length_limit     = var.id_length_limit == null ? var.context.id_length_limit : var.id_length_limit
    label_key_case      = var.label_key_case == null ? lookup(var.context, "label_key_case", null) : var.label_key_case
    label_value_case    = var.label_value_case == null ? lookup(var.context, "label_value_case", null) : var.label_value_case

  }


  enabled             = local.input.enabled
  regex_replace_chars = coalesce(local.input.regex_replace_chars, local.defaults.regex_replace_chars)

  string_label_names = ["namespace", "tenant", "environment", "stage", "name"]
  normalized_labels = { for k in local.string_label_names : k =>
    local.input[k] == null ? "" : replace(local.input[k], local.regex_replace_chars, local.replacement)
  }

  formatted_labels = { for k in local.string_label_names : k => local.label_value_case == "none" ? local.normalized_labels[k] :
    local.label_value_case == "title" ? title(lower(local.normalized_labels[k])) :
    local.label_value_case == "upper" ? upper(local.normalized_labels[k]) : lower(local.normalized_labels[k])
  }



  namespace   = local.formatted_labels["namespace"]
  tenant      = local.formatted_labels["tenant"]
  environment = local.formatted_labels["environment"]
  stage       = local.formatted_labels["stage"]
  name        = local.formatted_labels["name"]

  delimiter        = local.input.delimiter == null ? local.defaults.delimiter : local.input.delimiter
  label_order      = local.input.label_order == null ? local.defaults.label_order : coalescelist(local.input.label_order, local.defaults.label_order)
  id_length_limit  = local.input.id_length_limit == null ? local.defaults.id_length_limit : local.input.id_length_limit
  label_key_case   = local.input.label_key_case == null ? local.defaults.label_key_case : local.input.label_key_case
  label_value_case = local.input.label_value_case == null ? local.defaults.label_value_case : local.input.label_value_case
   

  tags_context = {
    namespace   = local.namespace
    tenant      = local.tenant
    environment = local.environment
    stage       = local.stage
    name       = local.id
  }

  id_context = {
    namespace   = local.namespace
    tenant      = local.tenant
    environment = local.environment
    stage       = local.stage
    name        = local.name
  }

  labels = [for l in local.label_order : local.id_context[l] if length(local.id_context[l]) > 0]

  id_full = join(local.delimiter, local.labels)
  # Create a truncated ID if needed
  delimiter_length = length(local.delimiter)
  output_context = {
    enabled             = local.enabled
    namespace           = local.namespace
    tenant              = local.tenant
    environment         = local.environment
    stage               = local.stage
    name                = local.name
    delimiter           = local.delimiter
    tags                = local.tags
    additional_tag_map  = local.additional_tag_map
    label_order         = local.label_order
    regex_replace_chars = local.regex_replace_chars
    id_length_limit     = local.id_length_limit
    label_key_case      = local.label_key_case
    label_value_case    = local.label_value_case  }

}