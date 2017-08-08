class Steps::FocusIsOn < Steps::Common

  def invoke(locator)
    node = find_node(locator, within: page)

    begin
      block_scroll = page.evaluate_script("document.querySelector('#{selector}').offsetTop")
    rescue
      raise ArgumentError, "Element #{locator} does not exist on page"
    end

    window_height = page.evaluate_script('window.innerHeight') / 2

    synchronize do
      scrolled = page.evaluate_script('document.body.scrollTop')

      (scrolled <= block_scroll && block_scroll <= scrolled + window_height) || raise(Capybara::ElementNotFound)
    end
  end
end
