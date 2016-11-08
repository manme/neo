# value object for store and serialization routes
class Route
  attr_reader :start_node, :start_time, :end_node, :end_time, :source

  def initialize(source, start_node, start_time, end_node, end_time)
    @source = source
    @start_node = start_node
    @start_time = start_time
    @end_node = end_node
    @end_time = end_time
  end

  def to_h
    datetime_format = "%FT%T"

    {
      start_node: @start_node,
      start_time: @start_time.strftime(datetime_format),
      end_node: @end_node,
      end_time: @end_time.strftime(datetime_format),
      source: @source
    }
  end
end