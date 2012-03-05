# SuAttrAccessibility

Using attr_accessible you can explicitly define what attributes of a model can be assigned.
As of Rails 3.1 this got even better as you can define different lists of attributes for different roles.

While this is all good and fine to protect your models from malicious input from outside (handled mostly in controllers), it will also make other interactions with your models somewhat harder: e.g. when testing or when in the console you always have to pass a role which can access the correct attributes.

This gem tries to solve this by letting you define roles that are allowed to access all attribites. It even makes it possible to forget all this role-stuff and only explicitly use roles in places where it matters (again: mostly in controllers).

## Installation

Add this line to your application's Gemfile:

    gem 'su_attr_accessibility'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install su_attr_accessibility

## Usage

```ruby
    class Person < ActiveRecord::Base
      belongs_to :account

      # attributes mass-assignable as role default
      attr_accessible :email

      # the admin-role can access all...
      su_attr_accessible_as :admin

      # ...even attributes defined later on
      attr_accessor :current_step
    end

    p1 = Person.new(:email => 'person1@example.org', :active => true)
    p1.email    # => 'person1@example.org'
    p1.active   # => nil
    p2 = Person.new({:email => 'person1@example.org', :active => true,
                      :account => Account.first, :current_step => 1},
                      :as => :admin)
    p2.email        # => 'person1@example.org'
    p2.active       # => true
    p2.current_step # => 2
    p2.account      # => <Account ...>
```

Alternatively the default-role is passed to su_attr_accessible_as and
another role is used for attr_accessible. This is more convenient when
working in the console for example (no ':as => :role' is needed) though
is less secure of course.

Enabling this behaviour by default for all subclasses of AR:

```ruby
    class ActiveRecord::Base
      def self.inherited(child_class)
        child_class.class_eval{ su_attr_accessible_as :default }
        super
      end
    end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Author

Gert Goet (eval) :: gert@thinkcreate.nl :: @gertgoet
