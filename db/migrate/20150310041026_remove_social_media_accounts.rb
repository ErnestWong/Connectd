class RemoveSocialMediaAccounts < ActiveRecord::Migration
  def change
    drop_table :social_media_accounts
  end
end
