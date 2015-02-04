class Employee::Collection < RecordCollection::Base
  attribute :section
  attribute :admin, type: Boolean
  attribute :vegan, type: Boolean
  validates :section, format: {with: /\A\w{3}\Z/ }
end
