class Idea < ActiveRecord::Base
  validates :name, presence: true
  validates_numericality_of :passion_rating, :only_integer => true, :less_than => 6, :greater_than => 0
  validates_numericality_of :skill_rating, :only_integer => true, :less_than => 6, :greater_than => 0
  validates_numericality_of :profit_rating, :only_integer => true, :less_than => 6, :greater_than => 0
end

# == Schema Information
#
# Table name: ideas
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  description    :string(255)
#  profit_rating  :integer
#  skill_rating   :integer
#  passion_rating :integer
#  created_at     :datetime
#  updated_at     :datetime
#
