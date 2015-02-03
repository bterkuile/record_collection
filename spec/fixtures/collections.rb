class Employee
  include ActiveAttr::Model


  class Collection < RecordCollection::Base
    attribute :section
    validates :section, format: {with: /\A\w{3}\Z/, if: 'section.present?' }
  end
end
