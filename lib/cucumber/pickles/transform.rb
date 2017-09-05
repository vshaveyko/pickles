within_reg = /\A\s*(.*)?\s*(?:["|'](.*?)["|'])?\s*\Z/

Transform(/(within .*)$/) do |within_info|
  splitted = within_info.split('within').reject(&:blank?)


  splitted.reverse_each.inject(page) do |within, info|
    captures = Helpers::Regex::WITHIN.match(info).captures
    el_alias = captures[0]
    locator = captures[1]

    Waiter.wait do
      within = Pickles.detect_node(el_alias, locator, within: within)
    end

    within
  end
end
