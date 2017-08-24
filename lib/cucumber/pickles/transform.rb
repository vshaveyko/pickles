within_reg = /\A\s*(.*)?\s*(?:["|'](.*?)["|'])?\s*\Z/

Transform(/(within .*)$/) do |within_info|
  splitted = within_info.split('within').reject(&:blank?)

  splitted.reverse_each.each_with_object(page) do |info, within|
    captures = Helpers::Regex::WITHIN.match(info).captures
    el_alias = captures[0]
    locator = captures[1]

    Pickles.detect_node(el_alias, locator, within: within)
  end
end
