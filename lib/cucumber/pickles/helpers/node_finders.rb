module NodeFinders

  using BlankMethod

  #
  # Finds text node by text locator
  #
  # @text - locator ( see locator docs in #Artifact )
  # @within: - within block to limit search to
  #
  # returns Capybara node
  #
  def find_node(locator, within: nil)
    within ||= Capybara.current_session

    options = { visible: false }

    locator, index = Locator::Index.execute(locator)
    locator, wait  = Locator::Wait.execute(locator)
    locator, xpath = Locator::Equal.execute(locator)

    if index
      xpath = "(#{xpath})[#{index}]"
    end

    if wait
      options[:wait] = wait
    end

    _rescued_find([:xpath, xpath, options], locator, within: within, message: "find_node") do
      raise Capybara::ElementNotFound,
            "Unable to find node by locator #{locator}",
            caller
    end
  end

  #
  # Does lookup based on provided in config maps
  #
  def detect_node(el_alias, locator = nil, within: nil)
    return find_node(locator, within: within) if el_alias.blank?

    within ||= Capybara.current_session

    locator, index = Locator::Index.execute(locator)

    if index.nil?
      el_alias, index = Locator::Index.execute(el_alias.to_s)
    end

    el_alias = el_alias.to_s

    if xpath = Pickles.config.xpath_node_map[el_alias]
      xpath = xpath.respond_to?(:call) ? xpath.call(locator) : xpath

      search_params = [:xpath, xpath, wait: 0, visible: false]
    elsif css = Pickles.config.css_node_map[el_alias] || el_alias
      css = css.respond_to?(:call) ? css.call(locator) : css

      search_params = [:css, css, text: locator, wait: 0, visible: false]
    end

    if index
      within.all(*search_params)[index - 1]
    else
      _rescued_find(search_params, locator || el_alias, within: within, message: "Detecting by #{xpath || css}") do
        raise Capybara::ElementNotFound,
              "Unable to detect node by locator #{css || xpath} #{locator}",
              caller
      end
    end
  end

  #
  # try to guess which of the above 2 methods should be used
  #
  def guess_node(within_string, within: nil)
    is_find_node_case = within_string[0] == "\"" && within_string[-1] == "\""

    match = Helpers::Regex::WITHIN.match(within_string)
    is_detect_node_case = !match.nil?

    if is_detect_node_case
      captures = match.captures
      el_alias = captures[0]
      locator = captures[1]

      detect_node(el_alias, locator, within: within)
    elsif is_find_node_case
      within_string[0]  = ''
      within_string[-1] = ''

      find_node(within_string, within: within)
    else
      fail "Incorrect within def"
    end
  end

  #
  # Similar to find_node, but looking for fillable fields for this cases:
  #  1. label or span(as label) with input hint for input || textarea || @contenteditable
  #  2. capybara lookup by label || plcaeholder || id || name || etc
  #  3. @contenteditable with @placeholder = @locator
  #
  # @input_locator - string to identify input field by
  #
  # returns: Capybara node
  #
  def find_input(input_locator, within: nil, options: {})
    within ||= Capybara.current_session

    locator, index       = Locator::Index.execute(input_locator)
    locator, wait        = Locator::Wait.execute(locator)
    locator, label_xpath = Locator::Equal.execute(locator)

    options[:visible] = false
    options[:wait]    = wait if wait

    if index
      index_xpath = "[#{index}]"
    end

    xpath = ".//*[@contenteditable and (@placeholder='#{locator}' or name='#{locator}')]#{index_xpath}"

    # case 3
    _rescued_find([:xpath, xpath, options], locator, within: within, message: "@contenteditable with placeholder = #{locator}") do

      inputtable_field_xpath = "*[self::input or self::textarea or @contenteditable]"

      xpath = "(#{label_xpath}/ancestor::*[.//#{inputtable_field_xpath}][position()=1]//#{inputtable_field_xpath})#{index_xpath}"

      _rescued_find([:xpath, xpath, options], locator, within: within, message: "find_node(#{locator}) => look for closest fillable field, index by input") do

        inputtable_field_xpath = "*[self::input or self::textarea or @contenteditable]"

        xpath = "(#{label_xpath})#{index_xpath}/ancestor::*[.//#{inputtable_field_xpath}][position()=1]//#{inputtable_field_xpath}"

        # case 1
        _rescued_find([:xpath, xpath, options], locator, within: within, message: "find_node(#{locator}) => look for closest fillable field, index by label") do

          # case 2
          _rescued_find([:fillable_field, locator, options], locator, index: index, within: within, message: 'Capybara#fillable_input') do

            # all cases failed => raise
            raise Capybara::ElementNotFound,
                                             "Unable to find fillable field by locator #{locator}",
                                             caller

          end

        end
      end

    end
  end

  def _rescued_find(params, locator, within:, message:, index: nil)
    if index
      within.all(*params)[index - 1]
    else
      within.find(*params)
    end
  rescue Capybara::Ambiguous => err # Capybara::Ambiguous < Capybara::ElementNotFound == true
    raise Pickles::Ambiguous.new(locator, within, params, message), nil, caller
  rescue Capybara::ElementNotFound
    yield
  end

end
