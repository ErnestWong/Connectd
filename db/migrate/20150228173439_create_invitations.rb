class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.integer :user_id
      t.integer :friend_id

      t.timestamps null: false
    end
  end
end
