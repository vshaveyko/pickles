Transform(/(within .*)$/) do |within_info|
  pry binding
  within_reg = /["|'](.*)["|']/

  splitted = within_info.split('within').reject(&:blank?)

  within_block = page

  splitted.reverse_each do |info|
    within_captures = within_reg.match(info).captures

    selector = within_captures[0]

    within_block = find_node(selector, within: within_block)
  end

  within_block
end
