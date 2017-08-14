Transform(/(within .*)$/) do |within_info|
  is_index_reg = /(.*)?\[(.*)\]/

  within_reg = /["|'](.*)["|']/

  splitted = within_info.split('within').reject(&:blank?)

  within_block = page

  splitted.reverse_each do |info|
    within_captures = within_reg.match(info).captures
    selector = within_captures[0]

    index_matches = is_index_reg.match(text)

    if index_matches
      text = index_matches.captures[0]
      index = index_matches.captures[1].to_i
      within_block = within_block.all(selector, text: text)[index]
    else
      within_block = find_node(selector, within: within_block)
    end

  end

  within_block
end
