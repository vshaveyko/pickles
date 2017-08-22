class NodeTextLookup

  class << self

    INDEX_REGEX = /(.*)?\[(.*)\]/

    def find_node(node_text, within_block: nil)
      within_block ||= Capybara.current_session

      text, selector = lookup_values(node_text)

      search_for_node(text, selector, within_block)
    end

    #
    # @in
    #   @step_text- step text
    # @out
    #   @text - formatted step text
    #   @selector - step selector
    #
    def lookup_values(step_text)
      if step_text.starts_with?('=')
        text = step_text[1..-1]

        selector = proc { |text| ".//*[text()='#{text}']" }
      else
        text = step_text

        #
        # find node that contains *text* and does not have any child nodes that contain *text*
        #

        selector = proc { |text| ".//*[contains(., '#{text}')][not(*[contains(., '#{text}')])]" }
      end

      [text, selector]
    end

    private

    #
    # @in
    #   @text
    #   @selector - from lookup_values
    #
    # @out
    #   node = capybara node
    #
    def search_for_node(text, selector, within_block)
      text, index_xpath = Artifact::Index.execute(text, '')

      xpath = "(#{selector.(text)})#{index_xpath}"

      within_block.find(:xpath, xpath)
    end

  end

end
