require 'rails_helper'

RSpec.describe Idea, :type => :model do
  it { is_expected.to respond_to(:name) }
  it { is_expected.to respond_to(:description) }
  it { is_expected.to respond_to(:profit_rating) }
  it { is_expected.to respond_to(:passion_rating) }
  it { is_expected.to respond_to(:skill_rating) }

  it { is_expected.to validate_numericality_of(:profit_rating).only_integer.is_less_than(6).is_greater_than(0) }
  it { is_expected.to validate_numericality_of(:passion_rating).only_integer.is_less_than(6).is_greater_than(0) }
  it { is_expected.to validate_numericality_of(:skill_rating).only_integer.is_less_than(6).is_greater_than(0) }

  it { is_expected.to validate_presence_of(:name) }

  it { is_expected.to allow_value(nil).for(:description)}
end
