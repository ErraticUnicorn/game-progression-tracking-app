# syntax=docker/dockerfile:1
ARG RUBY_VERSION=3.4.2
FROM ruby:$RUBY_VERSION-slim

WORKDIR /rails

# Install dependencies
RUN apt-get update -qq && apt-get install --no-install-recommends -y \
    build-essential git libpq-dev libyaml-dev curl postgresql-client && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Install gems early to take advantage of Docker caching
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Set environment variables
ENV RAILS_ENV="development"

# Expose Rails port
EXPOSE 3000

# Use a volume mount instead of copying files (handled in docker-compose.yml)
CMD ["rails", "server", "-b", "0.0.0.0"]
