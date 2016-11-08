module RouteTracer
  module Extractors
    class Sentinel < Base
      def routes
        routes_rows = hashes_from_rows(csv_rows('sentinels/routes.csv'))

        return if routes_rows.nil?

        routes_rows.group_by { |route| route[:route_id] }.each do |route_id, route_rows|
          extract_routes(route_rows)
        end

        extracted_routes
      end

      def extract_routes(route_rows)
        rows = route_rows.sort_by! { |x| x[:index] }
        rows.each_with_index do |start_row, index|
          next if (end_row = rows[index + 1]).nil?

          route = Route.new(source,
            start_row[:node],
            to_date_time(start_row[:time]),
            end_row[:node],
            to_date_time(end_row[:time]))

          add_extracted_route(route)
        end
      end

      def to_date_time(time)
        DateTime.strptime(time).new_offset(0)
      end

      def routes_rows
        @node_times_rows ||= csv_file_to_h('sentinels/routes.csv')
      end
    end
  end
end