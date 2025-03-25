class CreateGameEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :game_events do |t|
      t.references :user, null: false, foreign_key: true
      t.references :game, null: false, foreign_key: true
      t.integer :event_type
      t.datetime :occurred_at

      t.timestamps
    end

    add_index :user_games, [ :user_id, :game_id ], unique: true
  end
end
