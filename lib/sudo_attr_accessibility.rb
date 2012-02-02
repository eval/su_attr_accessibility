module SudoAttrAccessibility
  extend ActiveSupport::Concern

  module ClassMethods
    # Make all attributes of an AR-model accessible to some roles.
    #
    # @example
    #   class Person < ActiveRecord::Base
    #     belongs_to :account
    #
    #     # attributes mass-assignable as role default
    #     attr_accessible :email
    #
    #     # the admin-role can access all...
    #     sudo_attr_accessible_as :admin
    #
    #     # ...even attributes defined later on
    #     attr_accessor :current_step
    #   end
    #
    #   p1 = Person.new(:email => 'person1@example.org', :active => true)
    #   p1.email    # => 'person1@example.org'
    #   p1.active   # => nil
    #   p2 = Person.new({:email => 'person1@example.org', :active => true,
    #                     :account => Account.first, :current_step => 1},
    #                     :as => :admin)
    #   p2.email        # => 'person1@example.org'
    #   p2.active       # => true
    #   p2.current_step # => 2
    #   p2.account      # => <Account ...>
    #
    #   Alternatively the default-role is passed to sudo_attr_accessible_as and
    #   another role is used for attr_accessible. This is more convenient when
    #   working in the console for example (no ':as => :role' is needed) though
    #   is less secure of course.
    #
    #   Enabling this behaviour by default for all subclasses of AR:
    #   class ActiveRecord::Base
    #     def self.inherited(child_class)
    #       child_class.class_eval{ sudo_attr_accessible_as :default }
    #       super
    #     end
    #   end
    def sudo_attr_accessible_as(*roles)
      re_method_filter = %r{(.+)=\z}

      # take care of any future attribute
      unless respond_to?(:method_added_with_sudo_attr_accessibility)
        class_eval %{
          def self.method_added_with_sudo_attr_accessibility(m)
            if attribute = m.to_s[#{re_method_filter.inspect}, 1]
              attr_accessible attribute, :as => #{roles.inspect}
          end
            method_added_without_sudo_attr_accessibility(m)
            end

            class << self
            alias_method_chain :method_added, :sudo_attr_accessibility
            end
        }, __FILE__, __LINE__ + 1
      end

      # handle current attributes
      attributes = [].tap do |a|
        a.push *self.attribute_names
        a.push *self.instance_methods(false).map do |m|
          m.to_s[re_method_filter, 1]
        end.compact
      end.each do |attr|
        attr_accessible attr, :as => roles
      end
    end
  end
end
ActiveRecord::Base.send(:include, SudoAttrAccessibility)
