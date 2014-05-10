# encoding: utf-8

require "inherit/version"

# The `inherit` gem lets you avoid the anti-pattern of
# `def self.included(base); base.extend; ...; end`, without getting lost in
# subclassing.
#
# @see Module#inherit
# @see Object#inherit
#
# @example Usage
#     require 'inherit'
#
#     module MyProject
#       using Inherit
#     
#       module Inheritable
#         inheritable_constants do
#           Foo = "Nice constant!"
#         end
#         inheritable_class_methods do
#           def funky
#             "Funky class method!"
#           end
#         end
#         inheritable_instance_methods do
#           def rad
#             "Rad instance method!"
#           end
#         end
#         def self.inherited(subclass)
#           puts "#{self} got inherited by #{subclass}"
#         end
#         def self.extended(object)
#           puts "#{self} extended #{object}"
#         end
#       end
#     
#       class Example
#         inherit Inheritable # -> "Inheritable got inherited by Example"
#       end
#       p(Example::Foo)                  # => "Nice constant!"
#       p(Example.funky)                 # => "Funky class method!"
#       p(Example.new.rad)               # => "Rad instance method!"
#       a_string = "a string"
#       a_string.inherit Inheritable     # -> "Inheritable extended a string"
#       p(a_string.singleton_class::Foo) # => "Nice constant!"
#       p(a_string.rad)                  # => "Rad instance method!"
#     end
module Inherit

  refine Module do

    # Add constants, class methods and instance methods to a module/class.
    #
    # Adds the following things (if present) from `ancestor` to the module/class:
    #
    # * includes ancestor::Constants
    # * extends ancestor::ClassMethods
    # * includes ancestor::InstanceMethods
    #
    # Additionally it triggers `ancestor.inherited` with the module/class as argument.
    #
    # @param [Module] ancestor
    #   The module to add constants, class methods and instance methods from, and
    #   to trigger `.inherited` on.
    #
    # @see Inherit Usage example
    #
    def inherit(ancestor)
      include ancestor.inheritable_constants if ancestor.inheritable_constants?
      extend  ancestor.inheritable_class_methods if ancestor.inheritable_class_methods?
      include ancestor.inheritable_instance_methods if ancestor.inheritable_instance_methods?
      ancestor.inherited(self) if ancestor.respond_to?(:inherited)
      include ancestor
    end

    def inheritable_constants(&block)
      @inheritable_constants = Module.new(&block) if block
      @inheritable_constants
    end

    def inheritable_class_methods(&block)
      @inheritable_class_methods = Module.new(&block) if block
      @inheritable_class_methods
    end

    def inheritable_instance_methods(&block)
      @inheritable_instance_methods = Module.new(&block) if block
      @inheritable_instance_methods
    end

    def inheritable_constants?
      @inheritable_constants ? true : false
    end

    def inheritable_class_methods?
      @inheritable_constants ? true : false
    end

    def inheritable_instance_methods?
      @inheritable_constants ? true : false
    end
  end

  refine Object do
    # Add constants and instance methods to an object.
    #
    # Adds the following things (if present) from `ancestor` to the object:
    #
    # * extends ancestor::Constants
    # * extends ancestor::InstanceMethods
    #
    # Additionally it triggers `ancestor.extended` with the object as argument.
    #
    # @param [Module] ancestor
    #   The module to add constants and instance methods from, and to trigger
    #   `.extended` on.
    #
    # @see Inherit Usage example
    #
    def inherit(ancestor)
      extend ancestor.inheritable_constants if ancestor.inheritable_constants
      extend ancestor.inheritable_instance_methods if ancestor.inheritable_instance_methods
      extend ancestor
    end
  end
end
