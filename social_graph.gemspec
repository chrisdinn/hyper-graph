# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

Gem::Specification.new do |s|
  s.name        = "socialgraph"
  s.version     = "0.1.0"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Chris Dinn"]
  s.email       = ["chrisgdinn@gmail.com"]
  s.homepage    = "http://github.com/chrisdinn/SocialGraph"
  s.summary     = "A small library for accessing the Facebook Graph API " 
  s.files       = Dir['lib/*.rb'] + Dir['test/*.rb'] + %w(LICENSE README.md)
  
  s.add_dependency 'addressable'
  s.add_dependency 'json'
  
  s.require_path = 'lib'
end