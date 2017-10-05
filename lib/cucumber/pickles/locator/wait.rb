module Locator::Wait

  WAIT_REGEX = /\A([^\p{L}]*)(>)(.*)\Z/

  module_function

  def execute(locator)
    matches = WAIT_REGEX.match(locator)

    if matches
      captures = matches.captures
      locator = "#{captures[0]}#{captures[2]}"

      [locator, nil]
    else

      [locator, 0]
    end
  end

end
