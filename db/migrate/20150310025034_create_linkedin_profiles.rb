class CreateLinkedinProfiles < ActiveRecord::Migration
  def change
    create_table :linkedin_profiles do |t|

      t.timestamps null: false
    end
  end
end
