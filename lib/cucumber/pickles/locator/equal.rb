module Locator::Equal

  EQUAL_REGEX = /\A([^\p{L}]*)(=)(.*)\Z/

  module_function

  def execute(locator)
    matches = EQUAL_REGEX.match(locator)

    if matches
      captures = matches.captures
      locator = "#{captures[0]}#{captures[2]}"
      xpath = ".//*[text()='#{locator}']"

      [locator, xpath]
    else
      #
      # find node that contains *text* and does not have any child nodes that contain *text*
      #
      xpath = ".//*[contains(., '#{locator}')][not(*[contains(., '#{locator}')])]"

      [locator, xpath]
    end
  end

end
