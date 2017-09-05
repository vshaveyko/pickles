within_reg = /\A\s*(.*)?\s*(?:["|'](.*?)["|'])?\s*\Z/

Transform(/(within .*)$/) do |within_info|
  splitted = within_info.split('within').reject(&:blank?)

  Waiter.wait_for_ajax

  splitted.reverse_each.inject(page) do |within, info|
    captures = Helpers::Regex::WITHIN.match(info).captures
    el_alias = captures[0]
    locator = captures[1]

    Pickles.detect_node(el_alias, locator, within: within)
  end
end
