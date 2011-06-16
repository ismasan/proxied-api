require File.dirname(__FILE__) + '/api'
require 'rack/contrib'

use Rack::JSONP
run API