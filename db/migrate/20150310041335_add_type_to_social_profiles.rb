class AddTypeToSocialProfiles < ActiveRecord::Migration
  def change
    add_column :social_profiles, :type, :string
  end
end
