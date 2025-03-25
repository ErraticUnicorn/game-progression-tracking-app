require "test_helper"

class GameEventCreationTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create!(
      email: "gamer@example.com",
      password: "password123"
    )

    @game = Game.create!(
      id: 42,
      title: "Test Game",
      description: "A game for testing"
    )

    post "/api/sessions", params: {
      email: "gamer@example.com",
      password: "password123"
    }, as: :json

    @token = JSON.parse(response.body)["token"]
  end

  test "should create a completed game event with valid data" do
    occurred_at = Time.current.iso8601

    assert_difference "GameEvent.count", 1 do
      post "/api/user/game_events", params: {
        game_event: {
          game_id: @game.id,
          type: "COMPLETED",
          occurred_at: occurred_at
        }
      }, headers: { "Authorization" => "Bearer #{@token}" }, as: :json
    end

    assert_response :created

    json_response = JSON.parse(response.body)

    assert_not_nil json_response["id"]
    assert_equal @user.id, json_response["user_id"]
    assert_equal @game.id, json_response["game_id"]
    assert_equal "completed", json_response["event_type"]
    assert_equal occurred_at, json_response["occurred_at"]
    assert_not_nil json_response["created_at"]
    assert_not_nil json_response["updated_at"]

    game_event = GameEvent.last
    assert_equal @user.id, game_event.user_id
    assert_equal @game.id, game_event.game_id
    assert_equal "completed", game_event.event_type

    assert @user.games.include?(@game)
  end

  test "should return 404 when game_id not found" do
    post "/api/user/game_events", params: {
      game_event: {
        game_id: 999,
        type: "COMPLETED",
        occurred_at: Time.current
      }
    }, headers: { "Authorization" => "Bearer #{@token}" }, as: :json

    assert_response :not_found
    json_response = JSON.parse(response.body)
    assert_equal "Game not found", json_response["error"]
  end

  test "should return 422 with invalid data" do
    post "/api/user/game_events", params: {
      game_event: {
        game_id: @game.id,
        type: "COMPLETED"
      }
    }, headers: { "Authorization" => "Bearer #{@token}" }, as: :json

    assert_response :unprocessable_entity
    json_response = JSON.parse(response.body)
    assert json_response["errors"].join.include?("Occurred at")
  end

  test "should require authentication" do
    post "/api/user/game_events", params: {
      game_event: {
        game_id: @game.id,
        type: "COMPLETED",
        occurred_at: Time.current
      }
    }, as: :json

    assert_response :unauthorized
  end
end
