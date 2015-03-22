class Role < ActiveRecord::Base
  acts_as_authorization_role
end

# == Schema Information
#
# Table name: roles
#
#  id                :integer          not null, primary key
#  name              :string(255)      not null
#  authorizable_type :string(255)
#  authorizable_id   :integer
#  system            :boolean          default(FALSE), not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_roles_on_authorizable_type_and_authorizable_id  (authorizable_type,authorizable_id)
#  index_roles_on_name                                   (name)
#
