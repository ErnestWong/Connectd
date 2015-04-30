class AddInvitationToAuthorizations < ActiveRecord::Migration
  def change
    add_reference :authorizations, :invitation, index: true
    add_foreign_key :authorizations, :invitations
  end
end
