require 'test/unit'
require 'rubygems'
require 'bundler'

Bundler.setup(:default, :test)
Bundler.require(:default, :test)

require 'hyper_graph'
