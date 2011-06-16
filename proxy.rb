require 'rubygems'
require 'bundler'
Bundler.setup(:default, :proxy)

require 'proxymachine'

proxy do |data|
  if data =~ %r{^POST /themes}
    p "Proxying to uploads endpoint"
    { :remote => 'localhost:5100' } # eventmachine uploads
  else
    p "Proxying to REST API"
    { :remote => 'localhost:4000' } # API, or Nginx balancing API
  end
end