# README

Greetings, 

Within is a simple ruby on rails app.
The requirements are listed here.

## Dependencies

Ensure you have ruby, and ruby on rails installed. This can be done by following this guide:
https://gorails.com/setup/

Ensure you have Docker Compose usable

## Local Dev

After cloning the repository get started with docker compose:

`docker-compose build` followed by `docker-compose up -d`

The API will be available at `http://localhost:3000`

The db startup script may need permissions to run on your machine, if so run this command:
`chmod +x script/db_startup.sh`

Run `rake docker:seed` to add a game to the database.

## Running tests

To run tests simply run `rake docker:test` which assumes your running container has the name `elevate_labs_take_home-web-1`

## Metrics

This application provides Prometheus metrics to monitor its performance. The metrics endpoint is available at `/metrics`. To view in the browser visit: `http://localhost:3000/metrics`

### Available Metrics
  - `game_events_total`: Total game events by type
  - `user_registrations_total`: User registration count
  - `user_logins_total`: Successful login count
  - `user_login_failures_total`: Failed login attempts
  - `stats_processing_duration_seconds`: Time taken to process user statistics
  - And baked in rails metrics

## API Documentation

To interact with the API, a postman collection is provided as `game_completion_api_postman_collection.json`. Import this into Postman and one should be able to interact with the API pretty immediately.


## TODO
Scaling:
- Move event creation to a queue due concureency concerns of event endpoint
  - More event based architecture
- Make events idempotent (allows replaying of events)
- Can cache statistics
- Split services into auth/user/game
- Kubernetes load balancer
- Database scaling -> read replicas or sharding
  - separating write/read
  - transactions to ensure consistency across microservices
- More thorough unit tests
- Load testing

Product:
- Leaderboard-esque app
- Collect more game events
- Ensure data is easy to collect, (cron jobs to sort data)