# RecordCollection
[![Gem Version](https://badge.fury.io/rb/record_collection.svg)](http://badge.fury.io/rb/record_collection)
[![Build Status](https://travis-ci.org/bterkuile/record_collection.svg?branch=master)](https://travis-ci.org/bterkuile/record_collection)
[![Code Climate](https://codeclimate.com/github/bterkuile/record_collection/badges/gpa.svg)](https://codeclimate.com/github/bterkuile/record_collection)

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
   get :collection_edit
   post :collection_update
 end
```
So the route definition in `config/routes.rb` defined as:
```ruby
  collection_resources :employees, except: [:new]
```
is exactly the same as:
```ruby
  resources :employees, except: [:new] do
    collection do
      get :collection_edit
      post :collection_update
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
  validates :section, format: { with: /\A\w{3}\Z/ }
  attribute :admin, type: Boolean
  attribute :vegan, type: Boolean
end
```
See the [active_attr](https://github.com/cgriego/active_attr) gem for
attribute definitions.

### Validations
The validations for the collection are exactly the same as your
active_model validations. The only difference is that the allow_nil:
true option standard true is. Since a nil value of a collection attribute
means you do not want to change that value for the individual records.
To make an attribute explicitly required for a collection add the
allow_nil option:
```ruby
  validates :email, email: true, allow_nil: false
```

If the update on a record by the collection results in an invalid the
record will not be updated and the collection will not (yet) give the
feedback. The future idea is to create a `#invalid_records` attribute
that will contain those records

### The `.record_class` attribute
The record collection needs to know the class of the records it is
containing, since it need to share some of its behaviour. To do this a
collection assumes that it is subclassed by the model, eg:
```ruby
class Project::Prince2::Collection < RecordCollection::Base
end

Project::Prince2.record_class #=> Project::Prince2
```

If this is not the case, you have to define the record_class manually:
```ruby
class MyAwesomeCollection < RecordCollection::Base
  self.record_class = LpRecord
end
```

### The `after_record_update` hook
The collection implements a general `update(attributes)` method that will
update all the attributes that are set in the collection on the records it contains.
If you want to trigger a conditional for example a state machine trigger, you can do it like:

```ruby
class Project::Prince2::Collection < RecordCollection::Base
  after_record_update do |record|
    record.is_planned! if record.plan_date.present?
  end
end
```

## Defining your controllers
If you already used the specification `collection_resources :employees` in
your [config/routes.rb](spec/dummy/config/routes.rb) file you can add
the actions in your controller typically looking like:
```ruby
class EmployeesController < ApplicationController
  # your standard actions here

  # GET /employees/collection_edit?ids[]=1&ids[]=3&...
  def collection_edit
    @collection = Employee::Collection.find(params[:ids])
    redirect_to employees_path, alert: 'No employees selected' if @collection.empty?
  end

  # POST /employees/collection_update
  def collection_update
    @collection = Employee::Collection.find(params[:ids])
    if @collection.update params[:collection]
      redirect_to employees_path, notice: 'Collection is updated'
    else
      render 'collection_edit'
    end
  end  
end
```
For more advanced use of the collection the pattern above can of course
be different eg: different collection objects for the same active record
model types.

## Creating your views
The
[app/views/employess/collection_edit.html.slim](spec/dummy/app/views/employees/collection_edit.html.slim) view is a tricky one.
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

The form you create typically looks like [app/views/employees/collection_edit.html.slim](spec/dummy/app/views/employees/collection_edit.html.slim):
```slim
h1 Edit multiple employees
= form_for @collection, url: [:collection_update, @collection] do |f|
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
![Screenshot](docs/screenshot-multi-select-1.png?raw=true)

The idea behind working with collections is that you end up as a `GET` request at:
`+controller+/collection_edit?ids[]=2&ids[]=3` etc. How you achieve this
is totally up to yourself, but this gem provides you with a nice
standard way of selecting records from the index page. To filter records
to a specific subset the [ransack](https://github.com/activerecord-hackery/ransack)
gem also provides a nice way to add filtering to the index page. To add
checkbox selecting to your page this gem assumes the following
structure using the [Slim lang](http://slim-lang.com/)

[app/views/employees/index.html.slim](spec/dummy/app/views/employees/index.html.slim)
```slim
h1 Listing Employees
table.with-selection
  thead
    tr
      th Name
      th Section
  tbody
    - @employees.each do |employee|
      tr data-record=employee.attributes.to_json
        td= employee.name
        td= employee.section
```
Note that each row needs a json version of the record at least
containing its id.<br>
Implement the multiselect dependencies in your manifest files, typically
being
[app/assets/javascripts/application.js](spec/dummy/app/assets/javascriptss/application.js.coffee):
```javascript
//= require record_collection/multi_select
// Or require record_collection/all for all components
```
And for the styling provided by this gem ([app/assets/stylesheets/application.css](spec/dummy/app/assets/stylesheets/application.css.sass)):
```css
/*
 *= require record_collection/multi_select
 * Or require record_collection/all for all components
 */
```
The styling uses the [font-awesome-rails](http://fortawesome.github.io/Font-Awesome/) gem, so this gem should be
present in your `Gemfile`:
```ruby
gem 'font-awesome-rails'
```
Of course you are welcome to create your own awesome styling and send it
to me so I can add it as a theme :smile:.

To activate multi_select for your page put in your jQuery onload
function:

```javascript
$(function(){
  $(document).multi_select()
});
```

You can also apply it to dynamically loaded html replacing document for
the html added to your page:
```javascript
$.get('/ajax-page.html', function(response){
  $('#ajax-container').html(response);
  $('#ajax-container').multi_select();
});
```
### The selection action button
Selecting records from the tabble is the first step. Then going to the
edit page to edit the selection is another. At the moment there is not
yet a standardized solution in the `record_collection` gem, but with
your suggestions there will be one in the future. A current method can
be:
```slim
table.with-selection
  ...
  tfoot
    tr
      td
        button#selected-records-action Actions
```
And in your [app/assets/javascripts/application.js.coffee](spec/dummy/app/assets/javascriptss/application.js.coffee)
```coffeescript
$ ->
  if selector = $(document).multi_select()
    $('#selected-records-action').click ->
      ids = selector.selected_ids()
      return alert "No records selected" unless ids.length
      window.location = "/employees/collection_edit?#{$.param(ids: ids)}"
```
This indicates the controll you can implement on your collectoins.
Another way could be to use the less advicable way when the
[js-routes](https://github.com/railsware/js-routes) gem is added to just
have a button like:
```html
<button onclick="window.location = Routes.collection_edit_employees_path({ids: MultiSelect.selected_ids()})">Actions</button>
```
without any extra javascript.

## Optionals
![Screenshot](docs/screenshot-optionals-1.png?raw=true)
![Screenshot](docs/screenshot-optionals-2.png?raw=true)

Optionals is the name for the feature in this gem that activates
collection attributes to be sumitted in the form or not. Since for a
mixed collection on an attribute you might not want to edit, but another
attribute you do want to edit you add the optionals functionality to
your manifests. This is similar to the `multi_select` feature:
```javascript
//= require record_collection/optionals
// Or require record_collection/all for all components
```
And for the styling provided by this gem ([app/assets/stylesheets/application.css](spec/dummy/app/assets/stylesheets/application.css.sass)):
```css
/*
 *= require record_collection/optionals
 * Or require record_collection/all for all components
 */
```

To activate the optionals for your page put in your jQuery onload
function:

```javascript
$(function(){
  $(document).optionals()
});
```

You can also apply it to dynamically loaded html replacing document for
the html added to your page.

**TODO: more and better explanation about optionals**

## I18n translations
To manipulate the name of a collection and the standard `f.submit` form
label text add the following translation file
[config/locales/record_collection.en.yml](spec/dummy/config/locales/record_collection.en.yml)
```yml
en:
  activerecord:
    collections:
      employee: Group
  helpers:
    submit:
      collection:
        create: "Update %{model}"
```

## Generators
There is a scaffold generator available for collection resources. The
behaviour is very similar to the normal scaffold generator:
```bash
rails g collection_scaffold Project name:string finished:boolean description:text
``` 

This will generate the routes, model, migration, collection model and
views.

<b>NOTE:</b> At the moment only haml support for generated views.
Also note that the generators make an assumption about having the
following translations available:
```yml
en:
  action:
    create:
      successful: Successfully created %{model}
    update:
      successful: Successfully updated %{model}
    collection_update:
      successful: Successfully updated %{model} collection
    destroy:
      successful: Successfully destroyed %{model}
    new:
      link: New
    index:
      link: Back
    edit:
      link: Edit
    show:
      link: Show
```

## Special thanks

Special thanks for this project goes to:<br>
<a href="http://companytools.nl/" target="_blank"><img src="http://companytools.nl/assets/logo2-63318dd42aef154bd43548222b54be562f4c1059a4e7880892000224126d59bb.png" alt="Companytools"></a>
&nbsp;&nbsp;
<a href="http://fourstack.nl" target="_blank"><img src="http://fourstack.nl/logo1.png" alt="FourStack"></a>

## Contributing

1. Fork it ( https://github.com/bterkuile/record_collection/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
