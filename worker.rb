require 'rubygems'
require 'bundler'
Bundler.setup(:default, :workers)

require 'zmq'

ctx = ZMQ::Context.new(1) 

trap "INT", proc { ctx.terminate; exit }

pull_sock = ctx.socket(ZMQ::PULL)
# sleep 3
puts "Pull connecting"
pull_sock.connect('tcp://127.0.0.1:2200')

begin
  #Here we receive messages
  while message = pull_sock.recv
    sleep 3
    puts "Pull (#{Time.now}): I received a message"
    file = message.to_s.unpack('m').first
    
  end
#On termination sockets raise an error, lets handle this nicely
#Later, we'll learn how to use polling to handle this type of situation
#more gracefully
rescue StandardError => e
  puts "Socket terminated: #{e.inspect} - #{e.message}"
end