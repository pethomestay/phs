json.user do
  json.id @user.id
  json.token @user.hex
  json.facebook_id @user.uid
  json.first_name @user.first_name
  json.last_name @user.last_name
  json.image do
    json.partial! 'api/homestays/image', image: user_avatar(@user)
  end
end
