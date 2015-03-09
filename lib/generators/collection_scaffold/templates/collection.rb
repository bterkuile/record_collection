<% module_namespacing do -%>
class <%= class_name %>::Collection < RecordCollection::Base
<% attributes.each do |attribute| -%>
  attribute :<%= attribute.name %><%= collection_type_addition_for(attribute) %>
<% end -%>
end
<% end -%>
