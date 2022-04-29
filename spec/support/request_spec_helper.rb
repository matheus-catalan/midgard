module RequestSpecHelper
  def res
    response.body != '' ? JSON.parse(response.body) : response
  end

  def login(user)
    {
      headers: { 'Authorization' => "Bearer #{JWT.encode({ user_id: user.id }, ENV['hash_token'])}" }
    }
  end
end
