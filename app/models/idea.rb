class Idea < ActiveRecord::Base
  validates :name, presence: true
  validates_numericality_of :passion_rating, :only_integer => true, :less_than => 6, :greater_than => 0
  validates_numericality_of :skill_rating, :only_integer => true, :less_than => 6, :greater_than => 0
  validates_numericality_of :profit_rating, :only_integer => true, :less_than => 6, :greater_than => 0
end
