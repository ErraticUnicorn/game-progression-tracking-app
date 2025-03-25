module Api
  class GameEventsController < ApplicationController
    # POST /api/user/game_events
    def create
      game = Game.find_by(id: params[:game_event][:game_id])

      unless game
        return render json: { error: "Game not found" }, status: :not_found
      end

      current_user.user_games.find_or_create_by(game: game)

      event_type = if params[:game_event][:type] == "COMPLETED"
                    :completed
      else
                    :began
      end

      @event = current_user.game_events.new(
        game: game,
        event_type: event_type,
        occurred_at: params[:game_event][:occurred_at]
      )

      if @event.save
        Yabeda.game_events_total.increment({ event_type: event_type })
        render json: @event, status: :created
      else
        render json: { errors: @event.errors.full_messages },
               status: :unprocessable_entity
      end
    end
  end
end
