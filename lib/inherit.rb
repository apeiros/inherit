# encoding: utf-8

require 'inherit/version'

# The `inherit` gem lets you avoid the anti-pattern of
# `def self.included(base); base.extend …; end`, without getting lost in
# subclassing.
#
# @see Module#inherit
# @see Object#inherit
#
# @example Usage
#     require 'inherit'
#
#     module Inheritable
#       module Constants
#         Foo = "Nice constant!"
#       end
#       module ClassMethods
#         def funky
#           "Funky class method!"
#         end
#       end
#       module InstanceMethods
#         def rad
#           "Rad instance method!"
#         end
#       end
#       def self.inherited(subclass)
#         puts "#{self} got inherited by #{subclass}"
#       end
#       def self.extended(object)
#         puts "#{self} extended #{object}"
#       end
#     end
#     
#     class Example
#       inherit Inheritable # -> "Inheritable got inherited by Example"
#     end
#     Example::Foo                  # => "Nice constant!"
#     Example.funky                 # => "Funky class method!"
#     Example.new.rad               # => "Rad instance method!"
#     a_string = "a string"
#     a_string.inherit Inheritable  # -> "Inheritable extended a string"
#     a_string.singleton_class::Foo # => "Nice constant!"
#     a_string.rad                  # => "Rad instance method!"
module Inherit
end

class Module

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
    include ancestor::Constants if ancestor.const_defined?(:Constants)
    extend  ancestor::ClassMethods if ancestor.const_defined?(:ClassMethods)
    include ancestor::InstanceMethods if ancestor.const_defined?(:InstanceMethods)
    ancestor.inherited(self) if ancestor.respond_to?(:inherited)
  end
end

class Object

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
    extend ancestor::Constants if ancestor.const_defined?(:Constants)
    extend ancestor::InstanceMethods if ancestor.const_defined?(:InstanceMethods)
    ancestor.extended(self) if ancestor.respond_to?(:extended)
  end
end
