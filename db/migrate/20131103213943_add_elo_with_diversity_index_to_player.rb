class AddEloWithDiversityIndexToPlayer < ActiveRecord::Migration
  def change
    add_column :players, :ranking, :integer, default: 1000
    add_column :players, :reached_pro, :boolean, default: false
    add_column :players, :diversity_index, :float, default: 0.0
    add_column :players, :elo_with_diversity_index, :float, default: 0.0
  end
end
