class Steps::JsSelect < Steps::Common

  #
  # @value = value to select
  # @label = selector label to find
  #
  def invoke(value, label)
    input = find_input(label, within: page)

    input.set(value)

    Waiter.wait_for_ajax

    page.find_xpath(
      ".//*[contains(., '#{label}')][not(*[contains(., '#{label}')])]" \
      "/ancestor::*[.//*[text()=#{value}] and position() = 1]" \
      "/*[text()=#{value}]"
    ).click

    true
  end

end
