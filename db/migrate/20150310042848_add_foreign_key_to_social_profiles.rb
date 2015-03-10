class AddForeignKeyToSocialProfiles < ActiveRecord::Migration
  def change
    add_foreign_key :social_profiles, :users
  end
end
