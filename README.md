# SuAttrAccessibility

## Usage

Using `attr_accessible` you can explicitly define what attributes of a model can be mass assigned.
As of Rails 3.1 you can even specify these attributes per role.

So given the following model:

```ruby
# app/models/user.rb

# Table name: users
#
#  id                     :integer(4)      not null, primary key
#  name                   :string(255)
#  is_admin               :boolean(1)
class User < ActiveRecord::Base
  attr_accessible :name, :as => :user_input
end
```

...we stay safe when POSTed (possibly malicious) data is involved in mass assignment:

```ruby
> params = {:name => 'Gert', :is_admin => true}
> user = User.new(params, :as => :user_input)
WARNING: Can't mass-assign protected attributes: is_admin
=> "#<User id: nil, name: "Gert", is_admin: nil>"
```

While this is all good and fine for handling params in controllers, a whole lot of other parts of your application (e.g. tests, the console, any non-controller code) probably doesn't want to deal with these restrictions.

Though you could use `:without_protection => true` to bypass these restrictions, this gem let's you define a role that essentialy does the same:

```ruby
class User < ActiveRecord::Base
  attr_accessible :name, :as => :user_input
  su_attr_accessible_as :admin
end

> params = {:name => 'Gert', :is_admin => true}
> user = User.new(params, :without_protection => true)
=> "#<User id: nil, name: "Gert", is_admin: true>"
> user = User.new(params, :as => :admin)
=> "#<User id: nil, name: "Gert", is_admin: true>"
```

## But wait, there's more!

Do we really care about any role when we're *not* dealing with submitted data? Probably not.
This is when this gem is even better: we can pass the default-role to `su_attr_accessible_as` and forget about any role except for the parts where we really care:

```ruby
class User < ActiveRecord::Base
  attr_accessible :name, :as => :user_input
  su_attr_accessible_as :default
end

# on the console and in our tests:
> params = {:name => 'Gert', :is_admin => true}
> user = User.new(params)
=> "#<User id: nil, name: "Gert", is_admin: true>"

# in our controllers we keep using the user_input-role:
> user = User.new(params, :as => :user_input)
WARNING: Can't mass-assign protected attributes: is_admin
=> "#<User id: nil, name: "Gert", is_admin: nil>"
```

## Installation

Add this line to your application's Gemfile:

    gem 'su_attr_accessibility'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install su_attr_accessibility


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Author

Gert Goet (eval) :: gert@thinkcreate.nl :: @gertgoet
