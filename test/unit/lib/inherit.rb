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
    subclass.inherited_me
  end
  def self.extended(object)
    object.was_extended
  end
end



suite "Module#inherit" do
  test "callback" do
    test_class = Class.new do
      @inherited = false
      def self.inherited_me
        @inherited = true
      end
      def self.did_inherit
        @inherited
      end
    end

    assert !test_class.did_inherit
    test_class.inherit Inheritable
    assert test_class.did_inherit
  end

  test "constants" do
    test_class = Class.new do
      def self.inherited_me
      end
    end

    assert !test_class.const_defined?(:Foo)
    test_class.inherit Inheritable
    assert test_class.const_defined?(:Foo)
  end

  test "class methods" do
    test_class = Class.new do
      def self.inherited_me
      end
    end

    assert !test_class.respond_to?(:funky)
    test_class.inherit Inheritable
    assert test_class.respond_to?(:funky)
  end

  test "instance methods" do
    test_class = Class.new do
      def self.inherited_me
      end
    end

    assert !test_class.method_defined?(:rad)
    test_class.inherit Inheritable
    assert test_class.method_defined?(:rad)
  end
end

suite "Object#inherit" do
  test "callback" do
    test_object = Object.new.instance_eval do
      @inherited = false
      def was_extended
        @inherited = true
      end
      def did_inherit
        @inherited
      end
      self
    end

    assert !test_object.did_inherit
    test_object.inherit Inheritable
    assert test_object.did_inherit
  end

  test "constants" do
    test_object = Object.new.instance_eval do
      def was_extended
      end
      self
    end

    assert !test_object.singleton_class.const_defined?(:Foo)
    test_object.inherit Inheritable
    assert test_object.singleton_class.const_defined?(:Foo)
  end

  test "instance methods" do
    test_object = Object.new.instance_eval do
      def was_extended
      end
      self
    end

    assert !test_object.respond_to?(:rad)
    test_object.inherit Inheritable
    assert test_object.respond_to?(:rad)
  end
end
