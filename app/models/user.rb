class User < ApplicationRecord
  has_secure_password
  has_many :user_games
  has_many :games, through: :user_games
  has_many :game_events

  validates :email, presence: true, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }

  def stats
    {
      total_games_played: games_completed.count
    }
  end

  def games_completed
    Game.joins(:game_events)
        .where(game_events: { user_id: id, event_type: :completed })
        .distinct
  end
end
