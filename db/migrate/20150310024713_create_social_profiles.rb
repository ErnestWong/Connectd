class CreateSocialProfiles < ActiveRecord::Migration
  def change
    create_table :social_profiles do |t|

      t.timestamps null: false
    end
  end
end
