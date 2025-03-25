require 'test_helper'

class UserCreationTest < ActionDispatch::IntegrationTest
  test "should create a new user with valid attributes" do
    assert_difference 'User.count', 1 do
      post '/api/user', params: { 
        user: { 
          email: 'test@example.com', 
          password: 'password123', 
        } 
      }, as: :json
    end

    assert_response :created
    json_response = JSON.parse(response.body)
    assert_equal 'test@example.com', json_response['email']
    # Ensure password_digest is not returned in the response
    assert_nil json_response['password_digest']
  end

  test "should not create user with invalid email" do
    assert_no_difference 'User.count' do
      post '/api/user', params: { 
        user: { 
          email: 'invalid-email', 
          password: 'password123', 
        } 
      }, as: :json
    end

    assert_response :unprocessable_entity
    json_response = JSON.parse(response.body)
    assert json_response['errors'].any? { |error| error.include?('Email') }
  end

  test "should not create user with too short password" do
    assert_no_difference 'User.count' do
      post '/api/user', params: { 
        user: { 
          email: 'test@example.com', 
          password: 'short', 
        } 
      }, as: :json
    end

    assert_response :unprocessable_entity
    json_response = JSON.parse(response.body)
    assert json_response['errors'].any? { |error| error.include?('Password') }
  end

  test "should not create user with duplicate email" do
    post '/api/user', params: { 
      user: { 
        email: 'test@example.com', 
        password: 'password123', 
      } 
    }, as: :json
    
    assert_no_difference 'User.count' do
      post '/api/user', params: { 
        user: { 
          email: 'test@example.com', 
          password: 'different123', 
        } 
      }, as: :json
    end

    assert_response :unprocessable_entity
    json_response = JSON.parse(response.body)
    assert json_response['errors'].any? { |error| error.include?('Email') && error.include?('taken') }
  end
end