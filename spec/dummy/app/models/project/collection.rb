class Project::Collection < RecordCollection::Base
  attribute :finished, type: Boolean
  attribute :hint_visible, type: Boolean
  attribute :start_date, type: Date
  attribute :description
end
