class CreateAuthorizationsInvitationsTable < ActiveRecord::Migration
  def change
    create_table :authorizations_invitations, id: false do |t|
      t.references :authorization
      t.references :invitation
    end
  end
end
