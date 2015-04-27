class DropSocialProfiles < ActiveRecord::Migration
  def change
    drop_table :social_profiles
  end
end
