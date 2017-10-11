#
# Then I can see:
#   | Account Number | 5002       |
#   | body           | 2009-11-01 |
#   | .note          | Nice guy   |
#

Then(/^I can(not)? see:( within (?:.*))?$/) do |is_not, within_block, table|
  within_block ||= page

  if is_not
    check = -> within, content {
      within = within.strip.present? ? Pickles.guess_node(within, within: within_block) : within_block

      expect(within).not_to have_content(content)
    }
  else
    check = -> within, content {
      within = within.strip.present? ? Pickles.guess_node(within, within: within_block) : within_block

      expect(within).to have_content(content)
    }
  end

  Waiter.wait_for_ajax

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

And(/^I can(not)? see video (".*?")( within (?:.*))?$/) do |is_not, video_src, within|
  within ||= page
  if is_not
    expect(within).not_to have_selector("iframe[src=#{video_src}]")
  else
    expect(within).to have_selector("iframe[src=#{video_src}]")
  end
end

And(/^I can(not)? see image (".*?")( within (?:.*))?$/) do |is_not, image_src, within|
  within ||= page
  if is_not
    expect(within).not_to have_selector("img[src=#{image_src}]")
  else
    expect(within).to have_selector("img[src=#{image_src}]")
  end
end

Then /^focus is on (.*) ?"(.*?)"$/ do |identifier, locator|
  node = if identifier
           Pickles.detect_node(identifier, locator)
         else
           Pickles.find_node(locator, within: page)
         end

  block_scroll = page.evaluate_script("arguments[0].offsetTop", node)

  window_height = page.evaluate_script('window.innerHeight') / 2

  Waiter.wait do
    scrolled = page.evaluate_script('document.body.scrollTop')

    (scrolled <= block_scroll && block_scroll <= scrolled + window_height) || raise(Capybara::ElementNotFound)
  end
end
