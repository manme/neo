module RouteTracer
  module Extractors

    # common methods for all extractors
    class Base
      attr_reader :source

      def initialize(source, zip_data)
        @source = source

        RouteTracer::Utils.unzip(zip_data) do |file_name, data|
          add_file(file_name, data)
        end
      end

      #
      # input
      #
      def files
        @files
      end

      def add_file(file_name, data)
        return if file_name.to_s.empty? || data.to_s.empty?
        (@files ||= {})[file_name] = data
      end

      #
      # output
      #
      def extracted_routes
        @extracted_routes
      end

      def add_extracted_route(route)
        (@extracted_routes ||= []).push(route)
      end

      #
      # csv
      #
      def csv_file_to_h(file_name)
        return if files[file_name].nil?
        hashes_from_rows(csv_rows(file_name))
      end

      def hashes_from_rows(rows)
        header = rows.shift
        routes = rows.map do |row|
          row.each_with_index.inject({}) do |acc, (item, index)|
            acc.merge(Hash[header[index].strip.to_sym, item.strip])
          end
        end
      end

      def csv_rows(file_name)
        rows = CSV.parse(files[file_name].tr('"',''))
      end

      #
      # json
      #
      def json_file(file_name)
        return if files[file_name].nil?
        JSON.parse(files[file_name])
      end
    end
  end
end