class Pickles::Config

  attr_accessor :css_node_map, :xpath_node_map

  def initialize
    @css_node_map = {}
    @xpath_node_map = {}
    @fill_tag_steps_map = { 'select' => FillIN::Select }
    @check_tag_steps_map = {}
  end

  def css_node_map=(map)
    raise(ArgumentError, "Node map must be a hash") unless map.is_a?(Hash)

    @css_node_map = map.with_indifferent_access
  end

  def xpath_node_map=(map)
    raise(ArgumentError, "Node map must be a hash") unless map.is_a?(Hash)

    @xpath_node_map = map.with_indifferent_access
  end

  def fill_tag_steps_map=(map)
    raise(ArgumentError, "Node map must be a hash") unless map.is_a?(Hash)

    @fill_tag_steps_map.merge!(map)
  end

  def check_tag_steps_map=(map)
    raise(ArgumentError, "Node map must be a hash") unless map.is_a?(Hash)

    @check_tag_steps_map.merge!(map)
  end

  def step_by_tag(tag)
    @fill_tag_steps_map[tag]
  end

  def check_step_by_tag(tag)
    @check_tag_steps_map[tag]
  end

end
