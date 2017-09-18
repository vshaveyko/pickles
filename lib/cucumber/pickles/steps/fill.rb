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
When(/^(?:|I )fill in the following:( within (?:.*))?$/,
     &Pickles::StepDef.define_table_step([2, 3]) do |label, value, within|

  FillIN::Factory.new(label, value, within: within).call.call

end)

#   Waiter.wait_for_ajax
#
#   if fields.headers.length == 3
#     current_within = within
#
#     rows = fields.rows.unshift(fields.headers)
#
#     rows.each do |(within, label, value)|
#       case within
#       when Helpers::Regex::WITHIN
#         current_within = Pickles.detect_node($1, $2, within: within)
#       when "-"
#         current_within = within
#       end
#
#       if label['pry']
#         label['pry'] = ''
#
#         pry binding
#       end
#
#       FillIN::Factory.new(label, value, within: current_within).call.call
#     end
#   elsif fields.headers.length == 2
#     fields.rows_hash.each do |label, value|
#       pry binding if label['pry']
#       FillIN::Factory.new(label, value, within: within).call.call
#     end
#   else
#     raise(ArgumentError, 'Unsupported table type. Must contain 2 or 3 columns')
#   end
#
# end

# When /^(?:|I ) select "([^"]*)" from "([^"]*)"( within (?:.*))?$/ do |value, label, within|
#   FillIN::Select.new(label, value, within).call
# end

When /^(?:|I )(fill|select)(?: "([^"]*)")?(?: with "([^"]*)")?( within (?:.*))?$/ do |type, labels, value, within|
  if type == 'select' && value.present?
    FillIN::Select.new(labels, value, within).call
  else
    labels.split(/\s*\|\s*/).each do |label|
      FillIN::Factory.new(label, value, within: within).call.call
    end
  end
end

When /^(?:|I )attach the file "([^"]*)" to "([^"]*)"( within (?:.*))?$/ do |file_name, label, within|
  FillIN::Input.new(label, file_name, within).call
end
