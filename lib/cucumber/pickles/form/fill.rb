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
When /^(?:|I )fill in the following:( within (?:.*))?$/ do |within_block, fields|
  if fields.headers.length == 3
    current_within = within_block

    rows = fields.rows.unshift(fields.headers)

    rows.each do |(within, label, value)|
      case within
      when /\A(.+?)(?: "(.*)")?\Z/
        current_within = Pickles.detect_node($1, $2, within_block)
      when "-"
        current_within = within_block
      end

      FillIN::Factory.new(label, value, within_block: current_within).call.call
    end
  elsif fields.headers.length == 2
    fields.rows_hash.each do |label, value|
      FillIN::Factory.new(label, value, within_block: within_block).call.call
    end
  else
    raise(ArgumentError, 'Unsupported table type. Must contain 2 or 3 columns')
  end
end

When /^(?:|I ) select "([^"]*)" from "([^"]*)"( within (?:.*))?$/ do |value, label, within_block|
  FillIN::Select.new(label, value, within_block).call
end

When /^(?:|I )(?:select|unselect) "([^"]*)"( within (?:.*))?$/ do |labels, within_block|
  labels.split(/\s*\|\s*/).each do |label|
    FillIN::Input.new(label, nil, within_block).call
  end
end

When /^(?:|I )(?:fill|select|unselect)( select)?(?: "([^"]*)")?(?: with "([^"]*)")?( within (?:.*))?$/ do |is_select, label, value, within_block|
  if is_select
    FillIN::Select.new(label, value, within_block).call
  else
    FillIN::Factory.new(label, value, within_block: within_block).call.call
  end
end

When /^(?:|I )attach the file "([^"]*)" to "([^"]*)"( within (?:.*))?$/ do |file_name, label, within_block|
  FillIN::Input.new(label, file_name, within_block).call
end
