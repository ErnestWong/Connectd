json.users_results @users_results do |user|
  json.id user.id
  json.name user.full_name
  json.first_name user.first_name
  json.last_name user.last_name
  json.username user.username
end
