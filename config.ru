require File.join(File.dirname(__FILE__), *%w[application])

log = ::File.new("log/sinatra.log", "a")
# STDOUT.reopen(log)
# STDERR.reopen(log)

run Rack::URLMap.new "/"  => Sinatra::Application.new