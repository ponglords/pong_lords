require 'spec_helper'

describe Result do
  it { should validate_uniqueness_of(:player_id).scoped_to(:match_id) }
end
