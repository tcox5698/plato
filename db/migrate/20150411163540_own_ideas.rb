class OwnIdeas < ActiveRecord::Migration
  def change
    user = User.first
    Idea.all.each do | idea |
      user.has_role! :owner, idea
    end
  end
end
