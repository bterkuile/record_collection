CHANGELOG
=========

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
