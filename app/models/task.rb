class Task < ApplicationRecord
  belongs_to :user
  enum status: { pending: 0, completed: 1 }
end
