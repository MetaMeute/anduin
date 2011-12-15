def field_to_id(name)
  fields = {
    "Name"    => "asset_name",
    "Catalog" => "classification_catalog_id",
  }

  fields[name]
end

