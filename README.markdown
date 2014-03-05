README
======



Summary
-------

Avoid the anti-pattern of `def self.included(base); base.extend …; end`, without
getting lost in subclassing.



Installation
------------

`gem install inherit`



Usage
-----

    module Inheritable
      module Constants
        Foo = "Nice constant!"
      end
      module ClassMethods
        def funky
          "Funky class method!"
        end
      end
      module InstanceMethods
        def rad
          "Rad instance method!"
        end
      end
      def self.inherited(subclass)
        puts "#{self} got inherited by #{subclass}"
      end
      def self.extended(object)
        puts "#{self} extended #{object}"
      end
    end

    class Example
      inherit Inheritable # -> "Inheritable got inherited by Example"
    end
    Example::Foo                  # => "Nice constant!"
    Example.funky                 # => "Funky class method!"
    Example.new.rad               # => "Rad instance method!"
    a_string = "a string"
    a_string.inherit Inheritable  # -> "Inheritable extended a string"
    a_string.singleton_class::Foo # => "Nice constant!"
    a_string.rad                  # => "Rad instance method!"



Description
-----------

Avoid the anti-pattern of `def self.included(base); base.extend …; end`, without
getting lost in subclassing.



Links
-----

* [Online API Documentation](http://rdoc.info/github/apeiros/inherit/master/frames)
* [Public Repository](https://github.com/apeiros/inherit)
* [Bug Reporting](https://github.com/apeiros/inherit/issues)
* [RubyGems Site](https://rubygems.org/gems/inherit)



License
-------

You can use this code under the {file:LICENSE.txt BSD-2-Clause License}, free of charge.
If you need a different license, please ask the author.
