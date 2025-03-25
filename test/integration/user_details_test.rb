require "test_helper"

class UserDetailsTest < ActionDispatch::IntegrationTest
  def setup
    # Create a test user
    @user = User.create!(
      email: "statistics@example.com",
      password: "password123"
    )

    # Create two different games
    @game1 = Game.create!(
      id: 42,
      title: "Test Game 1",
      description: "First game for testing statistics"
    )

    @game2 = Game.create!(
      id: 43,
      title: "Test Game 2",
      description: "Second game for testing statistics"
    )

    # Get JWT token for authentication
    post "/api/sessions", params: {
      email: "statistics@example.com",
      password: "password123"
    }, as: :json

    @token = JSON.parse(response.body)["token"]

    @user.user_games.create!(game: @game1)
    @user.user_games.create!(game: @game2)

    2.times do
      @user.game_events.create!(
        game: @game1,
        event_type: :completed,
        occurred_at: Time.current
      )
    end

    @user.game_events.create!(
      game: @game2,
      event_type: :completed,
      occurred_at: Time.current
    )

    @user.game_events.create!(
      game: @game2,
      event_type: :began,
      occurred_at: Time.current
    )
  end

  test "should return user details with accurate stats" do
    get "/api/user", headers: { "Authorization" => "Bearer #{@token}" }, as: :json

    assert_response :success
    json_response = JSON.parse(response.body)

    assert_includes json_response, "user"
    user_data = json_response["user"]

    assert_equal @user.id, user_data["id"]
    assert_equal @user.email, user_data["email"]

    assert_includes user_data, "stats"
    stats = user_data["stats"]

    assert_equal 2, stats["total_games_played"],
                  "Expected 2 unique games played (each game counted only once), found #{stats['total_games_played']}"
  end

  test "should require authentication" do
    get "/api/user", as: :json

    assert_response :unauthorized
  end

  test "should count each game only once regardless of completion count" do
    @user.game_events.create!(
      game: @game1,
      event_type: :completed,
      occurred_at: Time.current
    )

    get "/api/user", headers: { "Authorization" => "Bearer #{@token}" }, as: :json

    assert_response :success
    stats = JSON.parse(response.body)["user"]["stats"]

    assert_equal 2, stats["total_games_played"],
                  "Games should be counted only once regardless of completion count"
  end
end
