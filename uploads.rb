require 'rubygems'
require 'bundler'
Bundler.setup(:default, :uploads_api)

require 'eventmachine'
require 'eventmachine_httpserver'
require 'evma_httpserver/response' # weird
require 'zmq'

CTX = ZMQ::Context.new(1) 
PUSH = CTX.socket(ZMQ::PUSH)
PUSH.bind('tcp://127.0.0.1:2200') # instead of bind(), so multiple PUSHs can connect to the same address

trap "INT", proc { puts "Terminating context"; CTX.terminate; exit }

class Handler  < EventMachine::Connection
  include EventMachine::HttpServer
 
  def process_http_request
    resp = EventMachine::DelegatedHttpResponse.new( self )
    
    puts "Uploads handler got request: sending to ZMQ"
    # puts @http_post_content.inspect
    
    PUSH.send(@http_post_content)
    
    # query our threaded server (max concurrency: 20)
    # http = EM::Protocols::HttpClient.request(
    #       :host => "localhost",
    #       :port => 4000,
    #       :verb => 'PUT',
    #       :request=>"/themes/current",
    #       :contenttype => @http_content_type,
    #       :content => @http_post_content
    #     )
    
    resp.status = 200
    resp.content = 'OK!'
    resp.send_response
    
    # once download is complete, send it to client
    # http.callback do |r|
    #       resp.status = 200
    #       resp.content = r[:content]
    #       resp.send_response
    #     end
 
  end
end
 
EventMachine::run {
  port = ENV['PORT'] || 5000
  EventMachine.epoll
  EventMachine::start_server("0.0.0.0", port, Handler)
  puts "Listening on port #{port}"
}