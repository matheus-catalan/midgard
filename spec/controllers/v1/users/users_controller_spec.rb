require 'rails_helper'

RSpec.describe 'Users resource', type: :request do
  include RequestSpecHelper
  describe 'INDEX' do
    it 'it should return all users' do
      count_users = rand(1..10)
      users = create_list(:user, count_users, :valid)
      get '/v1/users'

      expect(response).to have_http_status(200)
      expect(res['users']).to be_present
      expect(res['count_users']).to be_present
      expect(res['count_users']).to eq(count_users)

      users.each do |candidate|
        current_candidate = res['users'].select { |e| e['id'] == candidate.id }.first
        expect(current_candidate).not_to be_nil
        expect(candidate.id).to eq(current_candidate['id'])
        expect(candidate.uid).to eq(current_candidate['uid'])
        expect(candidate.name).to eq(current_candidate['name'])
        expect(candidate.email).to eq(current_candidate['email'])
        expect(candidate.status).to eq(current_candidate['status'])
      end
    end
  end

  # describe 'CREATE' do
  #   it 'it should create user and return user created' do
  #     user_payload = attributes_for(:user, :valid)
  #     post '/v1/users', params: { user: user_payload }

  #     expect(response).to have_http_status(200)
  #     expect(res['user']).to be_present

  #     user = User.find(res['user']['id'])

  #     expect(user.name).to eq(user_payload[:name])
  #     expect(user.email).to eq(user_payload[:email])
  #     expect(user.status).to eq(user_payload[:status])
  #     expect(user.authenticate(user_payload[:password])).to be_truthy
  #   end

  #   it 'it should not create user without name' do
  #     user_payload = attributes_for(:user, :without_name)
  #     post '/v1/users', params: { user: user_payload }
  #     expect(response).to have_http_status(422)
  #     expect(res['error']).to be_present
  #     expect(res['error']['name']).to eq(["can't be blank"])
  #   end

  #   it 'it should not create user without email' do
  #     user_payload = attributes_for(:user, :without_email)
  #     post '/v1/users', params: { user: user_payload }
  #     expect(response).to have_http_status(422)
  #     expect(res['error']).to be_present
  #     expect(res['error']['email']).to eq(["can't be blank", 'is invalid'])
  #   end

  #   it 'it should not create user with invalid email' do
  #     user_payload = attributes_for(:user, :with_invalid_email)
  #     post '/v1/users', params: { user: user_payload }
  #     expect(response).to have_http_status(422)
  #     expect(res['error']).to be_present
  #     expect(res['error']['email']).to eq(['is invalid'])
  #   end

  #   it 'it should not create user with email duplicated' do
  #     user = create(:user, :valid)
  #     user_payload = attributes_for(:user, :valid, email: user.email)
  #     post '/v1/users', params: { user: user_payload }
  #     expect(response).to have_http_status(422)
  #     expect(res['error']).to be_present
  #     expect(res['error']['email']).to eq(['has already been taken'])
  #   end

  #   it 'it should not create user without password' do
  #     user_payload = attributes_for(:user, :without_password)
  #     post '/v1/users', params: { user: user_payload }
  #     expect(response).to have_http_status(422)
  #     expect(res['error']).to be_present
  #     expect(res['error']['password']).to eq(["can't be blank"])
  #   end
  # end

  # describe 'SHOW' do
  #   it 'it should return user with id' do
  #     user = create(:user, :valid)

  #     get "/v1/users/#{user.id}"

  #     expect(response).to have_http_status(200)
  #     expect(user.name).to eq(res['user']['name'])
  #     expect(user.email).to eq(res['user']['email'])
  #     expect(user.status).to eq(res['user']['status'])
  #   end

  #   it 'it should not return user with id nonexistent' do
  #     create(:user, :valid)

  #     get "/v1/users/#{rand(1..100)}"

  #     expect(response).to have_http_status(404)
  #     expect(res['error']).to eq('User not found')
  #   end
  # end

  # describe 'UPDATE' do
  #   it 'it should updated user and return user updatedd' do
  #     user_id = create(:user, :valid).id
  #     user_payload = attributes_for(:user, :valid)
  #     put "/v1/users/#{user_id}", params: { user: user_payload }

  #     expect(response).to have_http_status(200)
  #     expect(res['user']).to be_present

  #     user = User.find(res['user']['id'])

  #     expect(user.name).to eq(user_payload[:name])
  #     expect(user.email).to eq(user_payload[:email])
  #     expect(user.status).to eq(user_payload[:status])
  #   end

  #   it 'it should not create user with id invalid' do
  #     create(:user, :valid).id
  #     user_payload = attributes_for(:user, :valid)
  #     put "/v1/users/#{rand(1..100)}", params: { user: user_payload }

  #     expect(response).to have_http_status(404)
  #     expect(res['error']).to eq('User not found')
  #   end

  #   it 'it should not create user with name invalid' do
  #     user_id = create(:user, :valid).id
  #     user_payload = attributes_for(:user, :with_invalid_name)
  #     put "/v1/users/#{user_id}", params: { user: user_payload }

  #     expect(response).to have_http_status(422)
  #     expect(res['error']).to be_present
  #     expect(res['error']['name']).to eq(['is too long (maximum is 50 characters)'])
  #   end

  #   it 'it should not update user with invalid email' do
  #     user_id = create(:user, :valid).id
  #     user_payload = attributes_for(:user, :with_invalid_email)
  #     put "/v1/users/#{user_id}", params: { user: user_payload }
  #     expect(response).to have_http_status(422)
  #     expect(res['error']).to be_present
  #     expect(res['error']['email']).to eq(['is invalid'])
  #   end

  #   it 'it should not create update with email duplicated' do
  #     user1 = create(:user, :valid)
  #     user2 = create(:user, :valid)
  #     user_payload = attributes_for(:user, :valid, email: user2.email)
  #     put "/v1/users/#{user1.id}", params: { user: user_payload }
  #     expect(response).to have_http_status(422)
  #     expect(res['error']).to be_present
  #     expect(res['error']['email']).to eq(['has already been taken'])
  #   end
  # end

  # describe 'DESTROY' do
  #   it 'it should destroy user and return user destroyd' do
  #     user = create(:user, :valid)

  #     delete "/v1/users/#{user.id}"

  #     expect(response).to have_http_status(200)
  #     expect(res['user']).to be_present

  #     expect(User.find_by(id: user.id)).to be_nil
  #   end

  #   it 'it should not destroy user with id invalid' do
  #     create(:user, :valid)

  #     delete "/v1/users/#{rand(1..100)}"

  #     expect(response).to have_http_status(404)
  #     expect(res['error']).to eq('User not found')
  #   end
  # end
end
