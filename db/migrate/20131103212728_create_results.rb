class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|
      t.belongs_to :player
      t.belongs_to :match
      t.boolean :won, default: false

      t.timestamps
    end
  end
end
