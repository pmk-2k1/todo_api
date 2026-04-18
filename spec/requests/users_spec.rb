require 'swagger_helper'

RSpec.describe 'Users API', type: :request do
  let(:admin) { User.create(email: 'admin@example.com', password: 'password', role: :admin) }
  let(:Authorization) { "Bearer #{JsonWebToken.encode(user_id: admin.id)}" }

  path '/users' do
    get 'Retrieves all users (Admin only)' do
      tags 'Users'
      security [ Bearer: [] ]
      response '200', 'users found' do
        run_test!
      end
    end
  end

  path '/users/{id}' do
    parameter name: :id, in: :path, type: :string

    patch 'Updates a user (Admin only)' do
      tags 'Users'
      security [ Bearer: [] ]
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          full_name: { type: :string },
          email: { type: :string },
          password: { type: :string },
          role: { type: :string, enum: [ 'user', 'admin' ] }
        }
      }

      response '200', 'user updated' do
        let(:id) { '1' }
        let(:user) { { full_name: 'Updated Name' } }
        run_test!
      end
    end

    delete 'Deletes a user (Admin only)' do
      tags 'Users'
      security [ Bearer: [] ]
      response '204', 'user deleted' do
        let(:id) { '1' }
        run_test!
      end
    end
  end

  path '/me' do
    get 'Retrieves current user' do
      tags 'Users'
      security [ Bearer: [] ]
      response '200', 'user found' do
        run_test!
      end
    end
  end

  path '/update_me' do
    patch 'Updates current user' do
      tags 'Users'
      security [ Bearer: [] ]
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          full_name: { type: :string },
          email: { type: :string },
          current_password: { type: :string },
          password: { type: :string },
          password_confirmation: { type: :string }
        }
      }

      response '200', 'user updated' do
        let(:user) { { full_name: 'Updated Name' } }
        run_test!
      end
    end
  end
end
