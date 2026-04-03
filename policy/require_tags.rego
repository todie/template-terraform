package terraform.policies.require_tags

# Required tags that must be present on all taggable resources.
required_tags := {"Environment", "ManagedBy", "Project"}

# Collect all resources that support tags.
taggable_resources[resource] {
  resource := input.resource_changes[_]
  resource.change.after.tags
}

# Deny resources missing any required tag.
deny[msg] {
  resource := taggable_resources[_]
  missing := required_tags - {tag | resource.change.after.tags[tag]}
  count(missing) > 0
  msg := sprintf(
    "Resource '%s' (%s) is missing required tags: %v",
    [resource.name, resource.type, missing],
  )
}

# Warn if tags contain empty values.
warn[msg] {
  resource := taggable_resources[_]
  tag := required_tags[_]
  value := resource.change.after.tags[tag]
  value == ""
  msg := sprintf(
    "Resource '%s' (%s) has an empty value for tag '%s'",
    [resource.name, resource.type, tag],
  )
}
