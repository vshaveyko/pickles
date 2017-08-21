#
# Then I can see:
#   | Account Number | 5002       |
#   | body           | 2009-11-01 |
#   | .note          | Nice guy   |
#
Then(/^I can(not)? see:$/) do |is_not, table|
  if is_not
    check = -> within, content {
      within = within.strip.present? ? find_node(within) : page

      expect(within).not_to have_content(content)
    }
  else
    check = -> within, content {
      within = within.strip.present? ? find_node(within) : page

      expect(within).to have_content(content)
    }
  end

  case table.headers.length
  when 1
    check = check.curry['']

    table.raw.flatten.each(&check)
  when 2
    table.rows_hash.each(&check)
  else
    raise ArgumentError, "Unsupported table format"
  end

end

And(/^I can(not)? see video (".*?")( within (?:.*))?$/) do |is_not, video_src, within_block|
  within_block ||= page
  if is_not
    expect(within_block).not_to have_selector("iframe[src=#{video_src}]")
  else
    expect(within_block).to have_selector("iframe[src=#{video_src}]")
  end
end

And(/^I can(not)? see image (".*?")( within (?:.*))?$/) do |is_not, image_src, within_block|
  within_block ||= page
  if is_not
    expect(within_block).not_to have_selector("img[src=#{image_src}]")
  else
    expect(within_block).to have_selector("img[src=#{image_src}]")
  end
end

# Then /^focus is on "(.*?)"$/ do |locator|
#   node = find_node(locator, within: page)
#
#   begin
#     block_scroll = page.evaluate_script("arguments[0].offsetTop", node)
#   rescue
#     raise ArgumentError, "Element #{locator} does not exist on page"
#   end
#
#   window_height = page.evaluate_script('window.innerHeight') / 2
#
#   synchronize do
#     scrolled = page.evaluate_script('document.body.scrollTop')
#
#     (scrolled <= block_scroll && block_scroll <= scrolled + window_height) || raise(Capybara::ElementNotFound)
#   end
# end
