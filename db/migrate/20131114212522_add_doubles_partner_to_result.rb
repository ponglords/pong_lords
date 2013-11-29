class AddDoublesPartnerToResult < ActiveRecord::Migration
  def change
    add_column :results, :doubles_partner_id, :integer
  end
end
