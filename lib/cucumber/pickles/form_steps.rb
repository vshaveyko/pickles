# Use this to fill in an entire form with data from a table. Example:
#
# When I fill in the following:
# |                 | Account Number       | 5002       |
# |                 | Expiry date          | 2009-11-01 |
# |                 | Note                 | Nice guy   |
# |                 | Wants Email?         |            |
# | User data       | Sex         (select) | Male       |
# |                 | Avatar               | avatar.png |
# |                 | Due date             | 12:35      |
# | Additional data | Accept user agrement | true       |
# |                 | Send me letters      | false      |
# |                 | radio 1              | true       |
#
def detect_node(el_alias, text, within_block)
  within_block ||= Capybara.current_session

  el_alias = el_alias.to_sym

  if xpath = Pickles.config.xpath_node_map[el_alias]
    return within_block.find(:xpath, xpath, wait: 0)
  end

  css = Pickles.config.css_node_map[el_alias] || el_alias

  within_block.find(:css, css, text: text, wait: 0)
end

When /^(?:|I )fill in the following:( within (?:.*))?$/ do |within_block, fields|
  if fields.headers.length == 3
    current_within = within_block

    rows = fields.rows.unshift(fields.headers)

    rows.each do |(within, label, value)|
      pry binding if label['pry']

      case within
      when /\A(.+?)(?: "(.*)")?\Z/
        current_within = detect_node($1, $2, within_block)
      when "-"
        current_within = within_block
      end

      Pickles::FillIn.invoke(label, value, current_within)
    end
  elsif fields.headers.length == 2
    fields.rows_hash.each do |label, value|
      pry binding if label['pry']

      Pickles::FillIn.invoke(label, value, within_block)
    end
  else
    raise(ArgumentError, 'Unsupported table type. Must contain 2 or 3 columns')
  end
end

# Use this to fill in an entire form with data from a table. Example:
#
# Then fields are filled with:
# | Account Number       | 5002       |
# | Expiry date          | 2009-11-01 |
# | Note                 | Nice guy   |
# | Wants Email?         | true       |
# | Sex                  | Male       |
# | Accept user agrement | true       |
# | Send me letters      | false      |
# | radio 1              | true       |
# | Avatar               | avatar.png |
# | Due date             | 12:35      |
Then /^fields are filled with:( within (?:.*))?$/ do |within_block, fields|

  fields.rows_hash.each do |label, value|

    if value[':']
      return if text_complex_input(label, value, within_block)
    end

    input = find_input(label, within_block: within_block).set(value)

    case input.native.attribute("type")

    when "text"
      expect(input.value).to eq value
    when "radio", "checkbox"
      case value

      when "true", true
        expect(input).to be_selected
      when "false", false, nil
        expect(input).not_to be_selected
      end
    when "file"
      expect(page).to have_selector("[src$='#{value}']")
    end

  end

end

When /^I select "([^"]*)" from "([^"]*)"( within (?:.*))?$/ do |value, label, within_block = 'body'|
  within within_block do
    step %{fill select "#{label}" with "#{value}"}
  end

  # input = find_input(label, within_block: within_block)
  #
  # input.set(value)
  #
  # Waiter.wait_for_ajax
  #
  # page.find_xpath(
  #   ".//*[contains(., '#{label}')][not(*[contains(., '#{label}')])]" \
  #   "/ancestor::*[.//*[text()=#{value}] and position() = 1]" \
  #   "/*[text()=#{value}]"
  # ).click
end

# When /^I (?:un)?select (?:checkbox|radio) "([^"]*)"(?: to state "([^"]*)")?( within (?:.*))?$/ do |label, field_state, within_block|
#   within within_block || 'body' do
#     step %{fill "#{label}" with ""}
#   end
# end

When /^(?:|I )(?:select|unselect) '([^"]*)'( within (?:.*))?$/ do |labels, within_block|
  labels.split(/\s*\|\s*/).each do |label|
    Pickles::FillIn.invoke(label, nil, within_block)
  end
end

When /^(?:|I )(?:fill|select|unselect)(select)?(?: "([^"]*)")?(?: with "([^"]*)")?( within (?:.*))?$/ do |is_select, label, value, within_block|
  Pickles::FillIn.invoke(label, value, within_block, is_select: is_select)
end

When /^(?:|I )attach the file "([^"]*)" to "([^"]*)"( within (?:.*))?$/ do |file_name, label, within_block|
  within within_block do
    step %{fill "#{label}" with "#{file_name}"}
  end
end
