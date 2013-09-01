class AddNamesToInvitation < ActiveRecord::Migration
  def change
    add_column :invitations, :first_name, :string, null: false, default: ""
    add_column :invitations, :last_name, :string, null: false, default: ""
  end
end
