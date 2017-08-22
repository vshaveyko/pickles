module Artifact::Index

  INDEX_REGEX = /(.*)?\[(.*)\]\s*$/

  module_function

  def execute(locator, xpath)
    index_matches = INDEX_REGEX.match(locator)

    return [locator, xpath] unless index_matches

    text = index_matches.captures[0]
    index = index_matches.captures[1].to_i

    [text, "#{xpath}[#{index}]"]
  end

end
