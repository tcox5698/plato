class CreateIdeas < ActiveRecord::Migration
  def change
    create_table :ideas do |t|
      t.string :name
      t.string :description
      t.integer :profit_rating
      t.integer :skill_rating
      t.integer :passion_rating

      t.timestamps
    end
  end
end
