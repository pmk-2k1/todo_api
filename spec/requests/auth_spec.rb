require 'swagger_helper'

RSpec.describe 'Auth API', type: :request do
  path '/register' do
    post 'Registers a new user' do
      tags 'Auth'
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string },
          password: { type: :string },
          full_name: { type: :string },
          role: { type: :string, enum: [ 'user', 'admin' ] }
        },
        required: [ 'email', 'password' ]
      }

      response '200', 'token generated' do
        let(:user) { { email: 'test@example.com', password: 'password', full_name: 'Test User', role: 'user' } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:user) { { email: 'invalid-email', password: 'password' } }
        run_test!
      end
    end
  end

  path '/login' do
    post 'Logs in a user' do
      tags 'Auth'
      consumes 'application/json'
      parameter name: :credentials, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string },
          password: { type: :string }
        },
        required: [ 'email', 'password' ]
      }

      response '200', 'token generated' do
        let(:credentials) { { email: 'test@example.com', password: 'password' } }
        before do
          User.create(email: 'test@example.com', password: 'password', role: 'user')
        end
        run_test!
      end

      response '401', 'unauthorized' do
        let(:credentials) { { email: 'test@example.com', password: 'wrong' } }
        run_test!
      end
    end
  end

  path '/logout' do
    delete 'Logs out a user' do
      tags 'Auth'
      security [ Bearer: [] ]
      response '200', 'logged out successfully' do
        let(:user) { User.create(email: 'logout@example.com', password: 'password') }
        let(:Authorization) { "Bearer #{JsonWebToken.encode(user_id: user.id)}" }
        run_test!
      end
    end
  end
end
