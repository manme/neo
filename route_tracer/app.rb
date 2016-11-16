require 'zipruby'
require 'faraday'
require 'csv'
require 'date'
require 'json'

module RouteTracer
  class App
    BASE_HOST = 'http://challenge.distribusion.com'
    BASE_PATH = '/the_one'
    ROUTES_PATH = [BASE_PATH, '/routes'].join
    SOURCES = %w(sentinels sniffers loopholes)

    attr_reader :routes

    def initialize(options)
      @passphrase = options[:passphrase]
    end

    # get and extract routes data
    def fetch
      @routes = []
      source_extractors.keys.each do |source|
        extract_routes(source, data_for_source(source))
      end
    end

    # post routes
    def send
      @routes.map do |route|
        connection.post(ROUTES_PATH, route.to_h)
      end
    end

    def extract_routes(source, data)
      extractor = source_extractors[source].new(source, data.body)
      @routes.push(*extractor.routes)
    end

    def source_extractors
      @source_extractors = {
        'sentinels' => RouteTracer::Extractors::Sentinel,
        'sniffers' => RouteTracer::Extractors::Sniffer,
        'loopholes' => RouteTracer::Extractors::Loophole
      }
    end

    def data_for_source(source)
      connection.get(ROUTES_PATH, { source: source })
    end

    def connection
      @connection ||= RouteTracer::ConnectionService.new(BASE_HOST, @passphrase)
    end
  end
end