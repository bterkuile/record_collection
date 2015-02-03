# RecordCollection

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'record_collection'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install record_collection

## Adding routes
Add two collection routes to the normal resources definition.
This call behaves exactly as the normal resources :... call, 
but adds:
```ruby
 collection do
   get :batch_actions
   post :process_batch
 end
```
So the route definition in `config/routes.rb` defined as:
```ruby
  batch_resources :employees, except: [:new]
```
is exactly the same as:
```ruby
  resources :employees, except: [:new] do
    collection do
      get :batch_actions
      post :process_batch
    end
  end
```

## Defining the collection
A good practice is to define your collection as a subclass of your
resource class. So an employees collection should be defined like:
`app/models/employee.rb`:
```ruby
class Employee < ActiveRecord::Base
  # attribute :admin, type: Boolean (defined by database)
  validates :name, presence: true
  
end
```
`app/models/employee/collection.rb`:
```ruby
class Employee::Collection < RecordCollection::Base
  attribute :admin, type: Boolean
  attribute :name
  validates :section, format: {with: /\A\w{3}\Z/, if: 'section.present?' }
end
```
See the [active_attr](https://github.com/cgriego/active_attr) gem for
attribute definitions.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/record_collection/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
