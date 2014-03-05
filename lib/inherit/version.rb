# encoding: utf-8

begin
  require 'rubygems/version' # newer rubygems use this
rescue LoadError
  require 'gem/version' # older rubygems use this
end

module Inherit

  # The version of the inherit gem.
  Version = Gem::Version.new("1.0.0")
end
