class Project::Collection < RecordCollection::Base
  attribute :finished, type: Boolean
  attribute :start_date, type: Date
  attribute :description
end
