source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.2"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.0.8"

# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 5.0"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem 'jbuilder', '~> 2.11', '>= 2.11.5'

# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 4.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', '~> 1.2023', '>= 1.2023.3', platforms: %i[ mingw mswin x64_mingw jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '~> 1.16', require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors', '~> 2.0', '>= 2.0.1'

gem 'jwt', '~> 2.7', '>= 2.7.1'
gem 'jsonapi-serializer', '~> 2.2'

gem 'colorize', '~> 1.1'

gem 'dotenv-rails', '~> 2.1', '>= 2.1.1', groups: [:development, :test]

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', '~> 1.8', platforms: %i[ mri mingw x64_mingw ]
  gem 'rspec-rails', '~> 6.0', '>= 6.0.3'
  gem 'factory_bot_rails', '~> 6.2'
  gem 'capybara', '~> 3.39', '>= 3.39.2'
  gem 'database_cleaner', '~> 2.0', '>= 2.0.2'
  gem 'faker', '~> 3.2', '>= 3.2.1'
  gem 'shoulda-matchers', '~> 5.3'
end

group :development do
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end

