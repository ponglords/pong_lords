json.player do
  json.id @player.id
  json.email @player.email
  json.first_name @player.first_name
  json.last_name @player.last_name
  json.nickname @player.nickname
end
