class Player < ActiveRecord::Base
  devise :database_authenticatable, :recoverable,
         :rememberable, :trackable, :validatable,
         :token_authenticatable, :lockable
end
