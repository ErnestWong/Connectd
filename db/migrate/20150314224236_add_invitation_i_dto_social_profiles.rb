class AddInvitationIDtoSocialProfiles < ActiveRecord::Migration
  def change
    add_column :social_profiles, :invitation_id, :integer
  end
end
