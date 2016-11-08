require 'zipruby'
require 'faraday'
require 'csv'
require 'date'
require 'json'

Dir['./route_tracer/**/*.rb'].each do |app|
  require app
end

app = RouteTracer::App.new(passphrase: 'Kans4s-i$-g01ng-by3-bye')

app.fetch
resp = app.send

resp.each { |r| p r.body; p r.status }