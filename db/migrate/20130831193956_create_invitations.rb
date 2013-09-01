class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.string :email, :null => false
      t.string :uuid, :null => false

      t.timestamps
    end
  end
end
