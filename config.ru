require File.join(File.dirname(__FILE__), *%w[application])

run Rack::URLMap.new "/"  => Sinatra::Application.new