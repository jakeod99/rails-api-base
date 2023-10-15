# Load the Rails application.
require_relative "application"

# Initialize the Rails application.
Rails.application.initialize!

unless ENV["QUIET_TESTING"]&.downcase == "true" && Rails.env.test?
  Rails.logger = Logger.new($stdout)
  Rails.logger.level = Logger::DEBUG
  Rails.logger.datetime_format = "%Y-%m-%d %H:%M:%S"
end
