require 'swagger_helper'

RSpec.describe 'Tasks API', type: :request do
  path '/tasks' do
    get 'Retrieves all tasks' do
      tags 'Tasks'
      security [Bearer: []]
      response '200', 'tasks found' do
        run_test!
      end
    end

    post 'Creates a task' do
      tags 'Tasks'
      security [Bearer: []]
      consumes 'application/json'
      parameter name: :task, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string },
          description: { type: :string },
          status: { type: :string, enum: ['pending', 'completed'] },
          time_start: { type: :string, format: 'date-time' },
          time_end: { type: :string, format: 'date-time' }
        },
        required: [ 'title' ]
      }

      response '200', 'task created' do
        let(:task) { { title: 'New Task' } }
        run_test!
      end
    end
  end

  path '/tasks/{id}' do
    parameter name: :id, in: :path, type: :string

    patch 'Updates a task' do
      tags 'Tasks'
      security [Bearer: []]
      consumes 'application/json'
      parameter name: :task, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string },
          description: { type: :string },
          status: { type: :string, enum: ['pending', 'completed'] }
        }
      }

      response '200', 'task updated' do
        let(:id) { '1' }
        let(:task) { { title: 'Updated Title' } }
        run_test!
      end
    end

    delete 'Deletes a task' do
      tags 'Tasks'
      security [Bearer: []]
      response '204', 'task deleted' do
        let(:id) { '1' }
        run_test!
      end
    end
  end
end
