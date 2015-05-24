module Acl9SpecHelper
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    @@registered_authorization_objects = []

    def acts_as_authorization_object
      @@registered_authorization_objects << self.class
    end

    def acts_as_authorization_object?
      @@registered_authorization_objects.include? self.class
    end
  end
end

ActiveRecord::Base.send(:include, Acl9SpecHelper)

RSpec::Matchers.define :act_as_authorization_object do
  match do |actual|
    actual.acts_as_authorization_object?
  end
end