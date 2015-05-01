json.users_results @users_results do |user|
  json.name user.full_name
  json.username user.username
end
