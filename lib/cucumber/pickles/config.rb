module Pickles

  class << self
    def configure
      yield config
    end

    def config
      @_configuration ||= Pickles::Config.new
    end
  end

end

class Pickles::Config

  using HashStringifyKeys

  attr_accessor :css_node_map, :xpath_node_map, :log_xhr_response

  def initialize
    @css_node_map = {}
    @log_xhr_response = false
    @xpath_node_map = {}
    @fill_tag_steps_map = { 'select' => FillIN::Select, 'jselect' => FillIN::JsSelect }
    @check_tag_steps_map = { 'text' => CheckIn::Text }
  end

  def css_node_map=(map)
    raise(ArgumentError, "Node map must be a hash") unless map.is_a?(Hash)

    @css_node_map = map.stringify_keys
  end

  def xpath_node_map=(map)
    raise(ArgumentError, "Node map must be a hash") unless map.is_a?(Hash)

    @xpath_node_map = map.stringify_keys
  end

  def fill_tag_steps_map=(map)
    raise(ArgumentError, "Node map must be a hash") unless map.is_a?(Hash)

    @fill_tag_steps_map.merge!(map.stringify_keys)
  end

  def check_tag_steps_map=(map)
    raise(ArgumentError, "Node map must be a hash") unless map.is_a?(Hash)

    @check_tag_steps_map.merge!(map.stringify_keys)
  end

  def step_by_tag(tag)
    @fill_tag_steps_map[tag]
  end

  def check_step_by_tag(tag)
    @check_tag_steps_map[tag]
  end

end
