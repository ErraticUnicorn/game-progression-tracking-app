require "prometheus/client"
require "yabeda/prometheus"
require "yabeda/rails"

# Initialize Yabeda with custom metrics
Yabeda.configure do
  # Game events metrics
  counter :game_events_total, comment: "Total number of game events recorded",
          tags: [ :event_type ]

  # User metrics
  counter :user_registrations_total, comment: "Total number of user registrations"
  counter :user_logins_total, comment: "Total number of successful logins"
  counter :user_login_failures_total, comment: "Total number of failed login attempts"

  # Stats processing metrics
  histogram :stats_processing_duration_seconds, comment: "Time taken to process user stats",
            unit: :seconds, buckets: [ 0.005, 0.01, 0.025, 0.05, 0.1, 0.25, 0.5, 1 ]
end

# Set up Prometheus metrics exporter
Yabeda.configure!
