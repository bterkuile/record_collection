CHANGELOG
=========

2015-12-26 - v0.10.3
--------------------
### Added
#### Add includes option for initializing a collection
```
  employees = Employee::Collection.includes(:project).where(state: 'active')
  employee.map(&:project) #=> one query
```

####
Add `#refine_relation` option to refine the collection by means of a
scope or include
```
  class Employee
    def self.with_project
      includes(:project)
    end
  end
  employees = Employee::Collection.where(state: 'active')
  employees.refine_relation{ with_project } #=> collection object with refined ActiveRecord relation object if it is instantiated as such
```

2015-12-26 - v0.10.2
--------------------
### Added
* Add append_text option for optional booleans

2015-12-26 - v0.10.1
--------------------
### Added
* Add hint option for optional booleans

2015-12-25 - v0.10.0
--------------------
### Changed
* renamed uniform_collection_attribute to uniform_collection_value

### Fixed
* Make optionals active when all the values in the collection are nil

2015-12-15 - v0.9.2
-------------------

### Added
#### Allow initialize with multiple chaning scope
```
Employee::Collection.where(a: 1).where(b: 3)
Employee::Collection.where(a: 1).where.not(b: 3)
```

2015-12-09 - v0.9.1
-------------------

### Added
* Use string separator argument like: RecordCollection.id\_separator

2015-11-03 - v0.9.0
-------------------

### Added
* Allow block without argument in before and after update hooks

2015-11-03 - v0.8.3
-------------------

### Added
* before\_record\_update hook


2015-11-03 - v0.8.2
-------------------

### Added
* Smarter find on collection object
