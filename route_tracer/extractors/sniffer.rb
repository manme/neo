module RouteTracer
  module Extractors
    class Sniffer < Base
      def routes
        return if routes_rows.nil? || node_times_rows.nil? || sequences_rows.nil?

        sequences_rows.each do |sequence|
          route = extract_route(sequence)
          add_extracted_route(route) if route
        end

        extracted_routes
      end

      def extract_route(sequence)
        return if (row = merge_rows_by(sequence)).nil?

        start_time = to_date_time(row[:time], row[:time_zone])
        duration = row[:duration_in_milliseconds]
        end_time = start_time + Rational(duration, 86400000) # milliseconds in a day

        Route.new(source,
          row[:start_node],
          start_time,
          row[:end_node],
          end_time)
      end

      def merge_rows_by(sequence)
        route_row = routes_rows.find do|row|
          row[:route_id] == sequence[:route_id]
        end

        node_times_row = node_times_rows.find do|row|
          row[:node_time_id] == sequence[:node_time_id]
        end

        return if route_row.nil? || node_times_row.nil?
        route_row.merge(node_times_row)
      end

      def to_date_time(time, time_zone)
        time_zone = time_zone.force_encoding('UTF-8').tr('±', '+').scan(/[\d:+-]/).join
        time = DateTime.strptime([time, time_zone].join).new_offset(0)
      end

      def routes_rows
        @routes_rows ||= csv_file_to_h('sniffers/routes.csv')
      end

      def node_times_rows
        @node_times_rows ||= csv_file_to_h('sniffers/node_times.csv')
      end

      def sequences_rows
        @sequences_rows ||= csv_file_to_h('sniffers/sequences.csv')
      end
    end
  end
end