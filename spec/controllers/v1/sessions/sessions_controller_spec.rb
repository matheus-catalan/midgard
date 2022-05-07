require 'rails_helper'

RSpec.describe 'Sessions resource', type: :request do
  include RequestSpecHelper
  describe 'INDEX' do
    it 'it should return all sessions' do
      count_sessions = rand(10..20)
      create_list(:session, count_sessions, :valid)

      get '/v1/sessions'

      expect(response).to have_http_status(200)
      expect(res['sessions']).to be_present
      expect(res['count_sessions']).to be_present
      expect(res['count_sessions']).to eq(count_sessions)
    end
  end

  describe 'CREATE' do
    it 'it should create session and authenticate user' do
      user = create(:user, :valid)

      post '/v1/sessions', params: {
        user: {
          email: user.email,
          password: user.password,
          should_expire: true
        },
        device: {
          name: 'iPhone',
          ip_address: Faker::Internet.ip_v4_address,
          user_agent: Faker::Internet.user_agent,
          platform: rand(0..1) == 0 ? 'ios' : 'android'
        }
      }

      expect(response).to have_http_status(200)
      expect(res['session']).to be_present
      expect(res['session']['token']).to eq(JWT.encode({ user_id: user.id }, ENV['SECRET_KEY_BASE']))
      expect(res['session']['expires_at'].to_datetime).to be <= Time.now + 1.day
      expect(res['session']['should_expire']).to eq(true)
    end

    it 'it should create session, create a new device when there is already one and authenticate user' do
      user = create(:user, :valid)
      create(:device, :valid, user: user)

      post '/v1/sessions', params: {
        user: {
          email: user.email,
          password: user.password,
          should_expire: true
        },
        device: {
          name: 'iPhone',
          ip_address: Faker::Internet.ip_v4_address,
          user_agent: Faker::Internet.user_agent,
          platform: rand(0..1) == 0 ? 'ios' : 'android'
        }
      }

      expect(response).to have_http_status(200)
      expect(res['session']).to be_present
      expect(res['session']['token']).to eq(JWT.encode({ user_id: user.id }, ENV['SECRET_KEY_BASE']))
      expect(res['session']['expires_at'].to_datetime).to be <= Time.now + 1.day
      expect(res['session']['should_expire']).to eq(true)
      expect(Device.count).to eq(2)
    end

    it 'it should not create sessions when email incorrect' do
      user = create(:user, :valid)

      post '/v1/sessions', params: {
        user: {
          email: Faker::Internet.email,
          password: user.password,
          should_expire: true
        },
        device: {
          name: 'iPhone',
          ip_address: Faker::Internet.ip_v4_address,
          user_agent: Faker::Internet.user_agent,
          platform: rand(0..1) == 0 ? 'ios' : 'android'
        }
      }

      expect(response).to have_http_status(401)
      expect(res['error']).to be_present
      expect(res['error']).to eq('Invalid email or password')
    end

  #   it 'it should not create sessions when password incorrect' do
  #     user = create(:user, :valid)

  #     post '/v1/sessions', params: {
  #       user: {
  #         email: user.email,
  #         password: Faker::Internet.password,
  #         should_expire: true
  #       },
  #       device: {
  #         name: 'iPhone',
  #         ip_address: Faker::Internet.ip_v4_address,
  #         user_agent: Faker::Internet.user_agent,
  #         platform: rand(0..1) == 0 ? 'ios' : 'android'
  #       }
  #     }

  #     expect(response).to have_http_status(401)
  #     expect(res['error']).to be_present
  #     expect(res['error']).to eq('Invalid email or password')
  #   end

  #   it 'it should not create sessions when device ip address incorrect' do
  #     user = create(:user, :valid)

  #     post '/v1/sessions', params: {
  #       user: {
  #         email: user.email,
  #         password: user.password,
  #         should_expire: true
  #       },
  #       device: {
  #         name: 'iPhone',
  #         ip_address: Faker::Internet.ip_v6_address,
  #         user_agent: Faker::Internet.user_agent,
  #         platform: rand(0..1) == 0 ? 'ios' : 'android'
  #       }
  #     }

  #     expect(response).to have_http_status(422)
  #     expect(res['error']).to be_present
  #     expect(res['error']['ip_address']).to eq(['is too long (maximum is 15 characters)', 'is invalid'])
  #   end

  #   it 'it should not create sessions when device without ip address' do
  #     user = create(:user, :valid)

  #     post '/v1/sessions', params: {
  #       user: {
  #         email: user.email,
  #         password: user.password,
  #         should_expire: true
  #       },
  #       device: {
  #         name: 'iPhone',
  #         user_agent: Faker::Internet.user_agent,
  #         platform: rand(0..1) == 0 ? 'ios' : 'android'
  #       }
  #     }

  #     expect(response).to have_http_status(422)
  #     expect(res['error']).to be_present
  #     expect(res['error']['ip_address']).to eq(["can't be blank", 'is invalid'])
  #   end

  #   it 'it should not create sessions when device without user agent' do
  #     user = create(:user, :valid)

  #     post '/v1/sessions', params: {
  #       user: {
  #         email: user.email,
  #         password: user.password,
  #         should_expire: true
  #       },
  #       device: {
  #         name: 'iPhone',
  #         ip_address: Faker::Internet.ip_v4_address,
  #         platform: rand(0..1) == 0 ? 'ios' : 'android'
  #       }
  #     }

  #     expect(response).to have_http_status(422)
  #     expect(res['error']).to be_present
  #     expect(res['error']['user_agent']).to eq(["can't be blank"])
  #   end

  #   it 'it should not create sessions when device without platform' do
  #     user = create(:user, :valid)

  #     post '/v1/sessions', params: {
  #       user: {
  #         email: user.email,
  #         password: user.password,
  #         should_expire: true
  #       },
  #       device: {
  #         name: 'iPhone',
  #         ip_address: Faker::Internet.ip_v4_address,
  #         user_agent: Faker::Internet.user_agent
  #       }
  #     }

  #     expect(response).to have_http_status(422)
  #     expect(res['error']).to be_present
  #     expect(res['error']['platform']).to eq(["can't be blank"])
  #   end

  #   it 'it should not create sessions without user' do
  #     post '/v1/sessions', params: {
  #       device: {
  #         name: 'iPhone',
  #         ip_address: Faker::Internet.ip_v4_address,
  #         user_agent: Faker::Internet.user_agent,
  #         platform: rand(0..1) == 0 ? 'ios' : 'android'
  #       }
  #     }

  #     expect(response).to have_http_status(422)
  #     expect(res['error']).to be_present
  #     expect(res['error']).to eq('param is missing or the value is empty: user')
  #   end

  #   it 'it should not create sessions without device' do
  #     user = create(:user, :valid)

  #     post '/v1/sessions', params: {
  #       user: {
  #         email: user.email,
  #         password: user.password,
  #         should_expire: true
  #       }
  #     }

  #     expect(response).to have_http_status(422)
  #     expect(res['error']).to be_present
  #     expect(res['error']).to eq('param is missing or the value is empty: device')
  #   end
  end

  # describe 'SHOW' do
  #   it 'it should update session with user logged' do
  #     user = create(:user, :valid)
  #     jwt = JWT.encode({ user_id: user.id }, ENV['SECRET_KEY_BASE'])
  #     session = create(:session, :valid, user: user, token: jwt)
  #     get '/v1/sessions/me',
  #         headers: { 'Authorization' => "Bearer #{jwt}" }

  #     expect(response).to have_http_status(200)
  #     expect(res['session']['token']).to eq(jwt)
  #     expect(res['session']['expires_at'].to_datetime).to be > session.expires_at.to_datetime
  #     expect(res['session']['should_expire']).to eq(session.should_expire)
  #     expect(res['user']).to eq({
  #                                 'id' => user.id,
  #                                 'email' => user.email,
  #                                 'name' => user.name,
  #                                 'uid' => user.uid,
  #                                 'status' => user.status
  #                               })
  #   end

  #   it 'it should not return session with user_id incorrect' do
  #     user = create(:user, :valid)
  #     jwt = JWT.encode({ user_id: rand(1..10) }, ENV['SECRET_KEY_BASE'])
  #     create(:session, :valid, user: user, token: jwt)
  #     get '/v1/sessions/me',
  #         headers: { 'Authorization' => "Bearer #{jwt}" }
  #     expect(response).to have_http_status(401)
  #     expect(res['error']).to eq('Unauthorized: User not found')
  #   end

  #   it 'it should not return session with user status false' do
  #     user = create(:user, :valid, status: false)
  #     jwt = JWT.encode({ user_id: user.id }, ENV['SECRET_KEY_BASE'])
  #     create(:session, :valid, user: user, token: jwt)
  #     get '/v1/sessions/me',
  #         headers: { 'Authorization' => "Bearer #{jwt}" }
  #     expect(response).to have_http_status(401)
  #     expect(res['error']).to eq('Unauthorized: User disabled')
  #   end

  #   it 'it should not return session with user not logged' do
  #     user = create(:user, :valid)
  #     jwt = JWT.encode({ user_id: user.id }, ENV['SECRET_KEY_BASE'])

  #     get '/v1/sessions/me',
  #         headers: { 'Authorization' => "Bearer #{jwt}" }
  #     expect(response).to have_http_status(401)
  #     expect(res['error']).to eq('Unauthorized: User not logged')
  #   end

  #   it 'it should not return session with token expired' do
  #     user = create(:user, :valid)
  #     jwt = JWT.encode({ user_id: user.id }, ENV['SECRET_KEY_BASE'])
  #     create(:session, :valid, user: user, token: jwt, expires_at: Time.now - 2.day)

  #     get '/v1/sessions/me',
  #         headers: { 'Authorization' => "Bearer #{jwt}" }
  #     expect(response).to have_http_status(401)
  #     expect(res['error']).to eq('Unauthorized: Token Bearer is expired')
  #   end

  #   it 'it should not return session without token' do
  #     user = create(:user, :valid)
  #     jwt = JWT.encode({ user_id: user.id }, ENV['SECRET_KEY_BASE'])
  #     create(:session, :valid, user: user, token: jwt, expires_at: Time.now - 2.day)

  #     get '/v1/sessions/me'
  #     expect(response).to have_http_status(401)
  #     expect(res['error']).to eq('Unauthorized: Token Bearer is missing')
  #   end
  # end

  # describe 'UPDATE' do
  #   it 'it should update session with user logged' do
  #     user = create(:user, :valid)
  #     jwt = JWT.encode({ user_id: user.id }, ENV['SECRET_KEY_BASE'])
  #     session = create(:session, :valid, user: user, token: jwt)
  #     should_expire = rand(0..1) == 0
  #     put '/v1/sessions',
  #         params: {
  #           user: {
  #             should_expire: should_expire
  #           }
  #         },
  #         headers: { 'Authorization' => "Bearer #{jwt}" }

  #     expect(response).to have_http_status(200)
  #     expect(res['session']['token']).to eq(jwt)
  #     expect(res['session']['expires_at'].to_datetime).to be > session.expires_at.to_datetime
  #     expect(res['session']['should_expire']).to eq(should_expire)
  #     expect(res['user']).to eq({
  #                                 'id' => user.id,
  #                                 'email' => user.email,
  #                                 'name' => user.name,
  #                                 'uid' => user.uid,
  #                                 'status' => user.status
  #                               })
  #   end

  #   it 'it should not update session with user_id incorrect' do
  #     user = create(:user, :valid)
  #     jwt = JWT.encode({ user_id: rand(1..10) }, ENV['SECRET_KEY_BASE'])
  #     create(:session, :valid, user: user, token: jwt)
  #     put '/v1/sessions',
  #         params: {
  #           user: {
  #             should_expire: rand(0..1) == 0
  #           }
  #         },
  #         headers: { 'Authorization' => "Bearer #{jwt}" }
  #     expect(response).to have_http_status(401)
  #     expect(res['error']).to eq('Unauthorized: User not found')
  #   end

  #   it 'it should not update session with user status false' do
  #     user = create(:user, :valid, status: false)
  #     jwt = JWT.encode({ user_id: user.id }, ENV['SECRET_KEY_BASE'])
  #     create(:session, :valid, user: user, token: jwt)
  #     put '/v1/sessions',
  #         params: {
  #           user: {
  #             should_expire: rand(0..1) == 0
  #           }
  #         },
  #         headers: { 'Authorization' => "Bearer #{jwt}" }
  #     expect(response).to have_http_status(401)
  #     expect(res['error']).to eq('Unauthorized: User disabled')
  #   end

  #   it 'it should not update session with user not logged' do
  #     user = create(:user, :valid)
  #     jwt = JWT.encode({ user_id: user.id }, ENV['SECRET_KEY_BASE'])

  #     put '/v1/sessions',
  #         params: {
  #           user: {
  #             should_expire: rand(0..1) == 0
  #           }
  #         },
  #         headers: { 'Authorization' => "Bearer #{jwt}" }
  #     expect(response).to have_http_status(401)
  #     expect(res['error']).to eq('Unauthorized: User not logged')
  #   end

  #   it 'it should not update session with token expired' do
  #     user = create(:user, :valid)
  #     jwt = JWT.encode({ user_id: user.id }, ENV['SECRET_KEY_BASE'])
  #     create(:session, :valid, user: user, token: jwt, expires_at: Time.now - 2.day)

  #     put '/v1/sessions',
  #         params: {
  #           user: {
  #             should_expire: rand(0..1) == 0
  #           }
  #         },
  #         headers: { 'Authorization' => "Bearer #{jwt}" }
  #     expect(response).to have_http_status(401)
  #     expect(res['error']).to eq('Unauthorized: Token Bearer is expired')
  #   end

  #   it 'it should not update session without token' do
  #     user = create(:user, :valid)
  #     jwt = JWT.encode({ user_id: user.id }, ENV['SECRET_KEY_BASE'])
  #     create(:session, :valid, user: user, token: jwt, expires_at: Time.now - 2.day)
  #     put '/v1/sessions', params: {
  #       user: {
  #         should_expire: rand(0..1) == 0
  #       }
  #     }

  #     expect(response).to have_http_status(401)
  #     expect(res['error']).to eq('Unauthorized: Token Bearer is missing')
  #   end
  # end

  # describe 'DESTROY' do
  #   it 'it should destroy session with user logged' do
  #     user = create(:user, :valid)
  #     jwt = JWT.encode({ user_id: user.id }, ENV['SECRET_KEY_BASE'])
  #     create(:session, :valid, user: user, token: jwt)
  #     delete '/v1/sessions',
  #            headers: { 'Authorization' => "Bearer #{jwt}" }

  #     p '=================================='
  #     p res['error']
  #     p '=================================='
  #     expect(response).to have_http_status(200)
  #     expect(res['session']['message']).to eq('Logged out successfully')
  #   end

  #   it 'it should not destroy session with user_id incorrect' do
  #     user = create(:user, :valid)
  #     jwt = JWT.encode({ user_id: rand(1..10) }, ENV['SECRET_KEY_BASE'])
  #     create(:session, :valid, user: user, token: jwt)
  #     delete '/v1/sessions',
  #            headers: { 'Authorization' => "Bearer #{jwt}" }
  #     expect(response).to have_http_status(401)
  #     expect(res['error']).to eq('Unauthorized: User not found')
  #   end

  #   it 'it should not destroy session with user status false' do
  #     user = create(:user, :valid, status: false)
  #     jwt = JWT.encode({ user_id: user.id }, ENV['SECRET_KEY_BASE'])
  #     create(:session, :valid, user: user, token: jwt)
  #     delete '/v1/sessions',
  #            headers: { 'Authorization' => "Bearer #{jwt}" }
  #     expect(response).to have_http_status(401)
  #     expect(res['error']).to eq('Unauthorized: User disabled')
  #   end

  #   it 'it should not destroy session with user not logged' do
  #     user = create(:user, :valid)
  #     jwt = JWT.encode({ user_id: user.id }, ENV['SECRET_KEY_BASE'])

  #     delete '/v1/sessions',
  #            headers: { 'Authorization' => "Bearer #{jwt}" }
  #     expect(response).to have_http_status(401)
  #     expect(res['error']).to eq('Unauthorized: User not logged')
  #   end

  #   it 'it should not destroy session with token expired' do
  #     user = create(:user, :valid)
  #     jwt = JWT.encode({ user_id: user.id }, ENV['SECRET_KEY_BASE'])
  #     create(:session, :valid, user: user, token: jwt, expires_at: Time.now - 2.day)

  #     delete '/v1/sessions',
  #            headers: { 'Authorization' => "Bearer #{jwt}" }
  #     expect(response).to have_http_status(401)
  #     expect(res['error']).to eq('Unauthorized: Token Bearer is expired')
  #   end

  #   it 'it should not destroy session without token' do
  #     user = create(:user, :valid)
  #     jwt = JWT.encode({ user_id: user.id }, ENV['SECRET_KEY_BASE'])
  #     create(:session, :valid, user: user, token: jwt, expires_at: Time.now - 2.day)
  #     delete '/v1/sessions'

  #     expect(response).to have_http_status(401)
  #     expect(res['error']).to eq('Unauthorized: Token Bearer is missing')
  #   end
  # end
end
