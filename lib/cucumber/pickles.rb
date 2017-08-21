unless defined?(SUPPORT_DIR)
  in_features_dir = caller.select { |path| path =~ /features/ }.first

  if in_features_dir
    features_dir = in_features_dir.split('/')

    2.times { features_dir.pop }

    SUPPORT_DIR = File.join(features_dir,'support')
  end
end

# :nodoc:
module Pickles

  class << self

    def configure
      yield config
    end

    def config
      @_configuration ||= Config.new
    end

  end

  module_function

  def wait_for_ajax
    Waiter.wait_for_ajax
  end

  def find_node(text, within: nil)
    NodeTextLookup.find_node(text, within_block: within)
  end

  def parent(el)
    el.find(:xpath, '..')
  end

  def detect_node(el_alias, text, within_block)
    within_block ||= Capybara.current_session

    el_alias = el_alias.to_sym

    if xpath = Pickles.config.xpath_node_map[el_alias]
      return within_block.find(:xpath, xpath, wait: 0)
    end

    css = Pickles.config.css_node_map[el_alias] || el_alias

    within_block.find(:css, css, text: text, wait: 0)
  end

  def find_input(locator, within_block: nil)
    within_block ||= Capybara.current_session

    begin
      xpath = ".//*[contains(text() ,'#{locator}')]/ancestor::*[.//*[self::input or self::textarea or @contenteditable]][1]//*[self::input or self::textarea or @contenteditable]"

      within_block.find(:xpath, xpath, wait: 0, visible: false)
    rescue Capybara::ElementNotFound
      within_block.find(:fillable_field, locator, wait: 0, visible: false)
    end
  end

  def blur(node)
    Capybara.current_session.execute_script("arguments[0].blur();document.body.click()", node)
  end

  def pickles_select_input(input, value = nil)
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
    Capybara.current_session.execute_script("arguments[0].click()", parent(input))
    Capybara.current_session.execute_script("arguments[0].checked = #{value}", input)
  end

  def pickles_attach_file(input, file)
    path = File.expand_path(File.join(SUPPORT_DIR,"attachments/#{file}"))

    raise RuntimeError, "file '#{path}' does not exists" unless File.exists?(path)

    input.set(path)
  end

  def syncronize(*errors)
    errors = errors.flatten

    errors << Capybara::ElementNotFound if errors.empty?

    page.document.synchronize(Capybara.default_max_wait_time, errors: errors) do
      yield
    end
  end

end

require 'cucumber/pickles/config'

# errors
require_relative 'pickles/errors/index_node_not_found'

# cucumber transforms
require 'cucumber/pickles/within_transform'

require_relative 'pickles/fill_in'
require_relative 'pickles/check_in'

# cucumber steps
require 'cucumber/pickles/form/fill'
require 'cucumber/pickles/form/check'

require 'cucumber/pickles/location_steps'
require 'cucumber/pickles/navigation_steps'

# helpers
require 'cucumber/pickles/helpers/waiter'
require 'cucumber/pickles/helpers/node_text_lookup'
