source "https://rubygems.org"

gem "rails", "~> 8.0.2"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "tzinfo-data", platforms: %i[ windows jruby ]
gem "bootsnap", require: false

# API Authentication
gem "bcrypt", "~> 3.1.7"
gem "jwt"

# CORS for API access
# gem "rack-cors" needed?

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "brakeman", require: false
  gem "rubocop-rails-omakase"
end
