# README

Greetings, 

Within is a simple ruby on rails app.

## Dependencies

Ensure you have ruby, and ruby on rails installed. This can be done by following this guide:
https://gorails.com/setup/

Ensure you have Docker Compose usable

## Local Dev

After cloning the repository get started with docker compose:

`docker-compose build` followed by `docker-compose up -d`

The API will be available at `http://localhost:3000`

## Running tests

To run tests simply run `rake docker:test` which assumes your running container has the name `elevate_labs_take_home-web-1`

## Metrics

This application provides Prometheus metrics to monitor its performance. The metrics endpoint is available at `/metrics`.

### Available Metrics
  - `game_events_total`: Total game events by type
  - `user_registrations_total`: User registration count
  - `user_logins_total`: Successful login count
  - `user_login_failures_total`: Failed login attempts
  - `stats_processing_duration_seconds`: Time taken to process user statistics
  - And baked in rails metrics

## API Documentation

To interact with the API, a postman collection is provided as `game_completion_api_postman_collection.json`. Import this into Postman and one should be able to interact with the API pretty immediately.
