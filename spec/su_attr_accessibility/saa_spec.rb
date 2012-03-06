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
  su_attr_accessible_as :default

  attr_accessible :name, :as => :form1
end

describe SuAttrAccessibility do
  it "allows all input from default" do

    params1    = {'age' => 12, 'name' => 'Gert'}
    expected1  = {'age' => nil, 'name' => 'Gert'}

    p1 = Person.new(params1, :as => :form1)
    p1.attributes.slice(*params1.keys).should == expected1

    params2    = {'age' => 12, 'name' => 'Gert'}
    expected2  = params2

    p2 = Person.new(params2)
    p2.attributes.slice(*params2.keys).should == expected2
  end
end
