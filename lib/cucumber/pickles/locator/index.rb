module Locator::Index

  INDEX_REGEX = /(.*)?\[(.*)\]\s*$/

  module_function

  def execute(locator)
    return [nil, nil] if locator.nil?

    matches = INDEX_REGEX.match(locator)

    return [locator, nil] unless matches

    text = matches.captures[0]
    index = matches.captures[1].to_i

    [text, index]
  end

end
