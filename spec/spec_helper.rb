require "rubygems"
require "bundler"
Bundler.setup

$:.unshift File.expand_path("../../lib", __FILE__)

require 'active_record'
require "sudo_attr_accessibility"

Bundler.require(:test)
