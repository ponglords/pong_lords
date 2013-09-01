json.invitation do
  json.email @invitation.email
  json.first_name @invitation.first_name
  json.last_name @invitation.last_name
  json.uuid @invitation.uuid
end
