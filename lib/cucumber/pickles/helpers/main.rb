require_relative 'node_finders'
require_relative 'waiter'

module Helpers::Main

  include NodeFinders
  include Waiter

  #
  # parent node of given
  #
  # @node - Capybara node
  #
  # returns Capybara node
  #
  def parent_node(node)
    node.find(:xpath, '..', wait: 0, visible: false)
  end

  #
  # trigger blur event on given node
  #
  # @node - Capybara node
  #
  def blur(node)
    trigger(node, 'blur')

    Capybara.current_session.execute_script("document.body.click()")
  end

  #
  # Select checkbox | radio input
  #
  # @input -            Capybara node with <input type="checkbox|radio">
  # @value - optional - value to set to input, Defaults to input state switch
  #
  # returns: [void]
  #
  def select_input(input, value = nil)
    case value
    when "true", true
      value = true
    when "false", false
      value = false
    else
      value = !input.checked?
    end

    #
    # Hack:
    #   cant use input.set(#{value})
    #   because element can be hidden or covered by other eement
    #   in which case Selenium raises error
    #
    trigger(parent_node(input), 'click')

    Capybara.current_session.execute_script("arguments[0].checked = #{value}", input)
  end

  #
  # Attach file from features/support/attachments/* to given file input
  #
  # @input - Capybara node with <input type="file">
  # @file  - file path relative to features/support/attachments/*
  #
  # returns [void]
  #
  def attach_file(input, file)
    path = File.expand_path(File.join(SUPPORT_DIR,"attachments/#{file}"))

    raise RuntimeError, "file '#{path}' does not exists" unless File.exists?(path)

    input.set(path)
  end

  #
  # Triggers event on node
  # Usefull when Capybara raises error about element being covered by another
  #
  # @node - Capybara node
  # @event - event to trigger
  #
  # returns: [void]
  def trigger(node, event)
    Capybara.current_session.execute_script("arguments[0].#{event}()", node)
  end

end
