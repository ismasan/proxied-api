# A sample Gemfile
source "http://rubygems.org"

gem 'mysql2', '< 0.3'
gem 'activerecord', '>= 3.0.0'

group :rest_api do
  gem 'sinatra'
  gem 'rack-contrib'
end

group :uploads_api do
  gem 'zmq'
  gem 'eventmachine'
  gem 'eventmachine_httpserver'
end

group :workers do
  gem 'zmq'
end

group :proxy do
  gem 'proxymachine'
end

group :development do
  gem 'shotgun'
end
