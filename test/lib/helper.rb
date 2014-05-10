# encoding: utf-8

require "stringio"
require "minitest/assertions"
require "minitest/test"
require "inherit"

module TestSuite
  attr_accessor :name
end

module Kernel
  def suite(name, &block)
    klass = Class.new(Minitest::Test)
    klass.extend TestSuite
    klass.name = "Suite #{name}"
    klass.class_eval(&block)

    klass
  end
  module_function :suite
end

module Minitest
  class Test
    def self.inherited(by)
      by.init
      super
    end

    def self.init
      @setups = []
    end

    def self.setup(&block)
      @setups ||= []
      @setups << block
    end

    class << self
      attr_reader :setups
    end

    def setup
      self.class.setups.each do |setup|
        instance_eval(&setup)
      end
      super
    end

    def self.suite(name, &block)
      klass = Class.new(Minitest::Test)
      klass.extend TestSuite
      klass.name = "Suite #{name}"
      klass.name = "#{self.name} #{name}"
      klass.class_eval(&block)

      klass
    end

    def self.test(desc, &impl)
      define_method("test_ #{desc}", &impl)
    end

    def capture_stdout
      captured  = StringIO.new
      $stdout   = captured
      yield
      captured.string
    ensure
      $stdout = STDOUT
    end
  end
end
