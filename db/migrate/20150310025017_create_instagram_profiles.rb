class CreateInstagramProfiles < ActiveRecord::Migration
  def change
    create_table :instagram_profiles do |t|

      t.timestamps null: false
    end
  end
end
