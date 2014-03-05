# encoding: utf-8

Gem::Specification.new do |s|
  s.name                      = "inherit"
  s.version                   = "0.0.1"
  s.authors                   = "Stefan Rusterholz"
  s.email                     = "stefan.rusterholz@gmail.com"
  s.homepage                  = "https://github.com/apeiros/inherit"
  s.license                   = 'BSD 2-Clause'

  s.description               = <<-DESCRIPTION.gsub(/^    /, '').chomp
    Avoid the anti-pattern of `def self.included(base); base.extend …; end`, without getting lost in subclassing.
  DESCRIPTION
  s.summary                   = <<-SUMMARY.gsub(/^    /, '').chomp
    Avoid the anti-pattern of `def self.included(base); base.extend …; end`, without getting lost in subclassing.
  SUMMARY

  s.files                     =
    Dir['bin/**/*'] +
    Dir['lib/**/*'] +
    Dir['rake/**/*'] +
    Dir['test/**/*'] +
    Dir['*.gemspec'] +
    %w[
      LICENSE.txt
      Rakefile
      README.markdown
    ]

  if File.directory?('bin') then
    s.executables = Dir.chdir('bin') { Dir.glob('**/*').select { |f| File.executable?(f) } }
  end

  s.add_development_dependency 'minitest', '>= 5.3.0'

  s.required_ruby_version     = ">= 1.9.2"
  s.rubygems_version          = "1.3.1"
  s.specification_version     = 3
  s.required_rubygems_version = Gem::Requirement.new("> 1.3.1")
end
