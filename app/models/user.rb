class User < ActiveRecord::Base
  acts_as_authorization_subject
  acts_as_authorization_object 
  authenticates_with_sorcery! do |config|
    config.authentications_class = Authentication
  end

  has_many :authentications, :dependent => :destroy
  accepts_nested_attributes_for :authentications

  validates :password, length: { minimum: 3 }
  validates :password, confirmation: true
  validates :password_confirmation, presence: true

#  validates :email, uniqueness: true

  def has_linked_github?
    authentications.where(provider: 'github').present?
  end
end

# == Schema Information
#
# Table name: users
#
#  id               :integer          not null, primary key
#  email            :string(255)      not null
#  crypted_password :string(255)
#  salt             :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#
