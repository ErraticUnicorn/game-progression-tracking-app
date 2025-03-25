class GameEvent < ApplicationRecord
  belongs_to :user
  belongs_to :game

  enum :event_type, began: 0, completed: 1

  validates :occurred_at, presence: true
  validates :event_type, presence: true

  scope :completed, -> { where(event_type: :completed) }
end
