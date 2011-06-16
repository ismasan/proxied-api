require 'rubygems'
require 'bundler'
Bundler.setup(:default, :rest_api)

require 'mysql2'
require 'active_record'
require 'sinatra'
require 'uri'

$:<< File.join(File.dirname(__FILE__), 'lib')

require 'product'

class API < Sinatra::Base
  
  configure do
    ActiveRecord::Base.include_root_in_json = false
    uri = URI.parse(ENV['BOOTIC_DB_URI'])
    ActiveRecord::Base.establish_connection(:adapter  => uri.scheme,
                                            :database => uri.path.sub('/',''),
                                            :username => uri.user,
                                            :password => uri.password.to_s,
                                            :host     => uri.host)
  end
  
  configure :production, :staging do
    disable :show_exceptions
  end
  
  before do
    content_type 'application/json'
  end
  
  error ActiveRecord::RecordNotFound do |error|
    halt 404, "Not Found"
  end
  
  get '/products' do
    Product.like(params[:q]).limit(10).to_json
  end
  
  get '/products/:id' do |id|
    Product.find(id).to_json
  end
  
  put '/themes/current' do
    puts '#' * 30
    puts 'HEADERS'
    puts '#' * 30
    sleep 3
    # puts request.env.inspect
    puts '#' * 30
    puts ''
    puts params.inspect
    FileUtils.mv(params['file'][:tempfile].path, File.dirname(__FILE__) + '/uploads/' + params['file'][:filename])
    halt 200, 'API Done!'
  end
  
end