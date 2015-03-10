class CreateTwitterProfiles < ActiveRecord::Migration
  def change
    create_table :twitter_profiles do |t|

      t.timestamps null: false
    end
  end
end
