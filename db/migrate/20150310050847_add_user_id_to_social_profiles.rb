class AddUserIdToSocialProfiles < ActiveRecord::Migration
  def change
    add_column :social_profiles, :user_id, :integer
  end
end
