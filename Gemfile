# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

ruby '3.0.2'

gem 'zeitwerk'
gem 'activerecord'
gem 'pg'
gem 'rake'

# faye layer
gem 'faye-websocket'
gem 'puma'

# async layer
gem 'async-websocket'
gem 'falcon'

group :development, :test do
  gem 'pry'
  gem 'rspec'
end
