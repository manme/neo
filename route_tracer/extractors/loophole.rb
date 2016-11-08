module RouteTracer
  module Extractors
    class Loophole < Base
      def routes
        return if routes_json.nil? || node_pairs_json.nil?
        routes_json['routes'].each do |route_hash|
          route = extract_route(route_hash)
          next if route.nil?
          add_extracted_route(route)
        end

        extracted_routes
      end

      def extract_route(route_hash)
        node_pair = node_pairs[route_hash['node_pair_id']]
        return nil if node_pair.nil?

        route = Route.new(source,
          node_pair['start_node'],
          to_date_time(route_hash['start_time']),
          node_pair['end_node'],
          to_date_time(route_hash['end_time']))
      end

      def node_pairs
        @node_pairs ||= node_pairs_json['node_pairs'].inject({}) do |acc, node_pair|
          acc.merge(Hash[node_pair['id'], node_pair])
        end
      end

      def to_date_time(time)
        DateTime.strptime(time).new_offset(0)
      end

      def routes_json
        @routes_json ||= json_file('loopholes/routes.json')
      end

      def node_pairs_json
        @node_pairs_json ||= json_file('loopholes/node_pairs.json')
      end
    end
  end
end