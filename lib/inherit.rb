# encoding: utf-8

require 'inherit/version'

module Inherit
end

class Module
  def inherit(ancestor)
    include ancestor::Constants if ancestor.const_defined?(:Constants)
    extend  ancestor::ClassMethods if ancestor.const_defined?(:ClassMethods)
    include ancestor::InstanceMethods if ancestor.const_defined?(:InstanceMethods)
    ancestor.inherited(self) if ancestor.respond_to?(:inherited)
  end
end

class Object
  def inherit(ancestor)
    extend ancestor::Constants if ancestor.const_defined?(:Constants)
    extend ancestor::InstanceMethods if ancestor.const_defined?(:InstanceMethods)
    ancestor.extended(self) if ancestor.respond_to?(:extended)
  end
end
