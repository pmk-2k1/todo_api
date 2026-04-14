require 'swagger_helper'

RSpec.describe 'Users API', type: :request do
  path '/users' do
    get 'Retrieves all users (Admin only)' do
      tags 'Users'
      security [Bearer: []]
      response '200', 'users found' do
        run_test!
      end
    end
  end

  path '/users/{id}' do
    parameter name: :id, in: :path, type: :string

    patch 'Updates a user (Admin only)' do
      tags 'Users'
      security [Bearer: []]
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          full_name: { type: :string },
          email: { type: :string },
          password: { type: :string },
          role: { type: :string, enum: ['user', 'admin'] }
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
      security [Bearer: []]
      response '204', 'user deleted' do
        let(:id) { '1' }
        run_test!
      end
    end
  end
end
