class Project::Collection < RecordCollection::Base
  attribute :finished, type: Boolean
  attribute :description
end
