class AddIndexesToGameEventsAndUserGames < ActiveRecord::Migration[8.0]
  def change
    add_index :user_games, [ :user_id, :game_id ], unique: true, if_not_exists: true

    add_index :game_events, [ :user_id, :game_id ], if_not_exists: true
    add_index :game_events, :event_type, if_not_exists: true
    add_index :game_events, [ :user_id, :game_id, :event_type ], if_not_exists: true
  end
end
