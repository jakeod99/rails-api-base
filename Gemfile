source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.2"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.0.8"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
gem "bcrypt", "~> 3.1.7"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", "~> 1.16", require: false

gem "colorize", "~> 1.1"

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

gem "jsonapi-serializer", "~> 2.2"

gem "jwt", "~> 2.7", ">= 2.7.1"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 5.0"

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem "rack-cors", "~> 2.0", ">= 2.0.1"

# Use Redis adapter to run Action Cable in production
gem "redis", "~> 4.0"

gem "sidekiq", "~> 7.1", ">= 7.1.5"

gem "sidekiq-cron", "~> 1.10", ">= 1.10.1"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", "~> 1.2023", ">= 1.2023.3", platforms: %i[mingw mswin x64_mingw jruby]

group :development, :test do
  gem "capybara", "~> 3.39", ">= 3.39.2"
  gem "database_cleaner", "~> 2.0", ">= 2.0.2"
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", "~> 1.8", platforms: %i[mri mingw x64_mingw]
  gem "dotenv-rails", "~> 2.1", ">= 2.1.1"
  gem "factory_bot_rails", "~> 6.2"
  gem "faker", "~> 3.2", ">= 3.2.1"
  gem "memory_profiler", "~> 1.0", ">= 1.0.1"
  gem "rack-mini-profiler", "~> 3.1", ">= 3.1.1"
  gem "rspec-rails", "~> 6.0", ">= 6.0.3"
  gem "shoulda-matchers", "~> 5.3"
  gem "stackprof", "~> 0.2.25"
  gem "standardrb", "~> 1.0", ">= 1.0.1"
end

group :development do
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end
