class Pickles::Config

  attr_accessor :css_node_map, :xpath_node_map

  def initialize
    @css_node_map = {}
    @xpath_node_map = {}
  end

  def css_node_map=(map)
    raise(ArgumentError, "Node map must be a hash") unless map.is_a?(Hash)

    @css_node_map = map.with_indifferent_access
  end

  def xpath_node_map=(map)
    raise(ArgumentError, "Node map must be a hash") unless map.is_a?(Hash)

    @xpath_node_map = map.with_indifferent_access
  end

end
