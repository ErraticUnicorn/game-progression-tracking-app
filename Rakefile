# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative "config/application"

Rails.application.load_tasks

namespace :docker do
  desc "Run Rails tests in the Docker container"
  task :test do |t, args|
    test_args = ARGV[1..-1].join(" ")
    sh "docker exec elevate_labs_take_home-web-1 bash -c 'cd /rails && bin/rails test #{test_args}'"
    exit 0
  end

  desc "Seed the database in the Docker container"
  task :seed do
    sh "docker exec elevate_labs_take_home-web-1 bash -c 'cd /rails && bin/rails db:seed'"
  end

  desc "Seed the test database in the Docker container"
  task :test_seed do
    sh "docker exec elevate_labs_take_home-web-1 bash -c 'cd /rails && RAILS_ENV=test bin/rails db:seed'"
  end
end
