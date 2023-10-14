# Put the ruby ​​version you are using
FROM ruby:3.2.2

# Install the necessary libraries
RUN apt-get update -qq && apt-get install -y postgresql-client

# BUNDLE_FROZEN setting
RUN bundle config --global frozen 1

# Set working directory
WORKDIR /rails-api-base

# Copy and install the project gems
COPY Gemfile /rails-api-base/Gemfile
COPY Gemfile.lock /rails-api-base/Gemfile.lock
RUN bundle install

# Run entrypoint.sh to delete server.pid
COPY docker-entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]

# Listen on this specified network port
EXPOSE 3000

# Run rails server
CMD ["rails", "server", "-b", "0.0.0.0"]
