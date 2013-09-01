class AddNamesToPlayer < ActiveRecord::Migration
  def change
    add_column :players, :first_name, :string, null: false, default: ""
    add_column :players, :last_name, :string, null: false, default: ""
    add_column :players, :nickname, :string, null: false, default: ""
  end
end
