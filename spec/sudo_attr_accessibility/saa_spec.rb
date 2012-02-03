require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

require 'sqlite3'

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database  => ":memory:")
ActiveRecord::Migration.verbose = false
ActiveRecord::Schema.define do
  create_table :people do |t|
    t.column :name, :string
    t.column :age, :integer

    t.timestamps
  end
end

class Person < ActiveRecord::Base
  attr_accessible :name
  sudo_attr_accessible_as :admin
end

describe SudoAttrAccessibility do
  it "should work" do
    p1 = Person.new(:age => 12)
    p1.age.should be_nil
  end
end
