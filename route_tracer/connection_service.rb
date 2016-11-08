module RouteTracer
  class ConnectionService
    def initialize(host, passphrase)
      @host = host
      @passphrase = passphrase
    end

    def get(path, params = {})
      conn.get do |req|
        req.url path, params.merge(passphrase: @passphrase)
        req.headers['Accept'] = 'application/json'
      end
    end

    def post(path, params = {})
      conn.post do |req|
        req.url path, params.merge(passphrase: @passphrase)
        req.headers['Accept'] = 'application/json'
      end
    end

    def conn
      @conn ||= Faraday.new(url: @host) do |faraday|
        faraday.request  :url_encoded             # form-encode POST params
        faraday.response :logger                  # log requests to STDOUT
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      end
    end
  end
end