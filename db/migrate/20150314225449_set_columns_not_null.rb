class SetColumnsNotNull < ActiveRecord::Migration
  def change
    change_column :invitations, :user_id, :integer, :null => false
    change_column :invitations, :friend_id, :integer, :null => false
    change_column :social_profiles, :user_id, :integer, :null => false
  end
end
