require "test_helper"

class SessionCreationTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create!(
      email: "test@example.com",
      password: "password123"
    )
  end

  test "should authenticate user with valid credentials" do
    post "/api/sessions", params: {
      email: "test@example.com",
      password: "password123"
    }, as: :json

    assert_response :ok

    json_response = JSON.parse(response.body)
    assert_not_nil json_response["token"]
    assert_not_nil json_response["exp"]
    assert_equal "test@example.com", json_response["email"]
    assert_equal @user.id, json_response["user_id"]
  end

  test "should reject authentication with invalid email" do
    post "/api/sessions", params: {
      email: "nonexistent@example.com",
      password: "password123"
    }, as: :json

    assert_response :unauthorized

    json_response = JSON.parse(response.body)
    assert_equal "Invalid credentials", json_response["error"]
  end

  test "should reject authentication with invalid password" do
    post "/api/sessions", params: {
      email: "test@example.com",
      password: "wrongpassword"
    }, as: :json

    assert_response :unauthorized

    json_response = JSON.parse(response.body)
    assert_equal "Invalid credentials", json_response["error"]
  end
end
