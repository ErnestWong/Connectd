class RemoveFacebookProfile < ActiveRecord::Migration
  def change
    drop_table :facebook_profiles
    drop_table :twitter_profiles
    drop_table :instagram_profiles
    drop_table :linkedin_profiles
  end
end
