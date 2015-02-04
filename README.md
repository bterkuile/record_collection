# RecordCollection
[<img src="https://secure.travis-ci.org/bterkuile/record_collection.png?branch=master" alt="Build Status" />](http://travis-ci.org/bterkuile/record_collection)

record\_collection is a gem that adds functionality to rails to work
with collections. This consists of a few components:

* Collection objects containing some active record models and acting on
  that collection.
* the multi\_select helpers for selecting records from the index page
* the optionals helpers for managing attributes on the collection of
  records you may or may not want to edit in the collection form

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
   get :batch_edit
   post :batch_update
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
      get :batch_edit
      post :batch_update
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
  attribute :name
  validates :section, format: {with: /\A\w{3}\Z/, if: 'section.present?' }
  attribute :admin, type: Boolean
  attribute :vegan, type: Boolean
end
```
See the [active_attr](https://github.com/cgriego/active_attr) gem for
attribute definitions.

## Defining your controllers
If you already used the specification `batch_resources :employees` in
your [config/routes.rb](spec/dummy/config/routes.rb) file you can add
the actions in your controller typically looking like:
```ruby
class EmployeesController < ApplicationController
  # your standard actions here

  # GET /employees/batch_edit?ids[]=1&ids[]=3&...
  def batch_edit
    @collection = Employee::Collection.find(params[:ids])
    redirect_to employees_path, alert: 'No employees selected' if @collection.empty?
  end

  # POST /employees/batch_update
  def batch_update
    @collection = Employee::Collection.find(params[:ids])
    if @collection.update params[:collection]
      redirect_to employees_path, notice: 'Collection is updated'
    else
      render 'batch_edit'
    end
  end  
end
```
For more advanced use of the collection the pattern above can of course
be different eg: different collection objects for the same active record
model types.

## Creating your views
The
[app/views/employess/batch_edit.html.slim](spec/dummy/app/views/employees/batch_edit.html.slim) view is a tricky one.
Since we are working on a collection of record, and want to edit those
attributes we just want a normal form for editing the attributes,
treating the collection as the record itself. The problem however is
that some attributes can be in a mixed state, say two employees, one
having `admin => true`, the other one `admin => false`. If I only want
to update the section they are both in, I want to leave the admin
attribute allone. To accomplish this, this gem provides the `optional`
helpers. These helpers make it easy to manage a form of attributes where
you can determine which attributes you want to manage for this
particular collection of records. This gem also support [simple_form](https://github.com/plataformatec/simple_form)
gem where you can replace `f.input :attribute, ...etc` with
`f.optional_input :attribute, ...etc`. Our current example works with
the standard [form_helpers](http://guides.rubyonrails.org/form_helpers.html)<br>
### currently supported helpers:
* `optional_boolean`
* `optional_text_field`
* `optional_input` ([simple_form](https://github.com/plataformatec/simple_form))

The form you create typically looks like [app/views/employees/batch_edit.html.slim](spec/dummy/app/views/employees/batch_edit.html.slim):
```slim
h1 Edit multiple employees
= form_for @collection, url: [:batch_update, @collection.record_class] do |f|
  = f.collection_ids
  .form-inputs= f.optional_text_field :section
  .form-inputs= f.optional_boolean :admin
  .form-inputs= f.optional_boolean :vegan
  .form-actions= f.submit
.page-actions
  = link_to 'Back', employees_path
```

That is the view part. Be sure to read the optionals section for a
better understanding of how the optional fields work.

## Selecting records from the index using checkboxes (multi_select)
The idea behind working with collections is that you end up as a `GET` request at:
`+controller+/batch_edit?ids[]=2&ids[]=3` etc. How you achieve this
is totally up to yourself, but this gem provides you with a nice
standard way of selecting records from the index page. To filter records
to a specific subset the [ransack](https://github.com/activerecord-hackery/ransack)
gem also provides a nice way to add filtering to the index page. To add
checkbox selecting to your page this gem assumes the following
structure using the [Slim lang](http://slim-lang.com/):
```slim
table.with-selection
  thead
    tr
      th Name
      th Section
  tbody
    - @employees.each do |employee|
      tr data-record=employee.attributes.to_json
```
Note that each row needs a json version of the record at least
containing its id.<br>
Implement the multiselect dependencies in your manifest files, typically
being `app/assets/javascripts/application.js`:
```javascript
//= require record_collection/multi_select
```
And for the styling provided by this gem ([app/assets/stylesheets/application.css](spec/dummy/app/assets/stylesheets/application.css.sass)):
```css
/*
 *= require record_collection/multi_select
 */
```
The styling uses the [font-awesome-rails](http://fortawesome.github.io/Font-Awesome/) gem, so this gem should be
present in your `Gemfile`:
```ruby
gem 'font-awesome-rails'
```
Of course you are welcome to create your own awesome styling and send it
to me so I can add it as a theme :smile:.

## Optionals
Optionals is the name for the feature in this gem that activates
collection attributes to be sumitted in the form or not. Since for a
mixed collection on an attribute you might not want to edit, but another
attribute you do want to edit you add the optionals functionality to
your manifests. This is similar to the `multi_select` feature:
```javascript
//= require record_collection/optionals
```
And for the styling provided by this gem ([app/assets/stylesheets/application.css](spec/dummy/app/assets/stylesheets/application.css.sass)):
```css
/*
 *= require record_collection/optionals
 */
```

**TODO: more explanation about optionals**

## Special thanks

Special thanks for this project goes to:<br>
<a href="http://companytools.nl/" target="_blank"><img src="http://companytools.nl/assets/logo2-f5f9a19c745e753a4d52b5c0a1a7c6d7.png" alt="Companytools"></a>
&nbsp;&nbsp;
<a href="http://fourstack.nl" target="_blank"><img src="http://fourstack.nl/logo1.png" alt="FourStack"></a>
&nbsp;&nbsp;
<a href="http://www.kpn.com" target="_blank"><img src="http://www.kpn.com/ss/Satellite/yavUnLl8hN7yMh6Gh2IPWqYD60HbUkXsNK4iD8PcUpR0bnBXyZZtwQUuCgSUG72CJE/MungoBlobs/kpn_logo.png"></a>

## Contributing

1. Fork it ( https://github.com/bterkuile/record_collection/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
