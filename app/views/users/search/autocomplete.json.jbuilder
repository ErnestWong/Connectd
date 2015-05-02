json.users_results @users_results do |user|
  json.id user.id
  json.name user.full_name
  json.username user.username
end
