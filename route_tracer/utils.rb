module RouteTracer
  class Utils
    def self.unzip(data)
      Zip::Archive.open_buffer(data) do |archive|
        archive.each do |entry|
          yield entry.name, entry.read
        end
      end
    end
  end
end