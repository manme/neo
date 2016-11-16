Dir['./env.rb', './route_tracer/**/*.rb'].each do |app|
  require app
end

app = RouteTracer::App.new(passphrase: ENV['PASSWORD'])

app.fetch
resp = app.send

resp.each { |r| p r.body; p r.status }