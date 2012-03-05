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
  include SuAttrAccessibility

  attr_accessible :name
  su_attr_accessible_as :admin
end

describe SuAttrAccessibility do
  it "let's admin assign protected attributes" do
    p1 = Person.new(:age => 12)
    p1.age.should be_nil

    p2 = Person.new({:age => 12}, :as => :admin)
    p2.age.should == 12
  end
end
