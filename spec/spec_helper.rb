require "rubygems"
require "bundler"
Bundler.setup

$:.unshift File.expand_path("../../lib", __FILE__)

require 'active_record'
require "su_attr_accessibility"

Bundler.require(:test)
