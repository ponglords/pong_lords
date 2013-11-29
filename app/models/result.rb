class Result < ActiveRecord::Base
  belongs_to :match
  belongs_to :player
  belongs_to :doubles_partner, class_name: "Player"

  validates_uniqueness_of :player_id, scope: :match_id
end
