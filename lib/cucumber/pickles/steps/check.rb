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
Then(/^fields are filled with:( within (?:.*))?$/,
     &Pickles::StepDef.define_table_step([2, 3]) do |label, value, within|

  CheckIn::Factory.new(label, value, within: within).call.call

end)

# do |within, fields|
#
#   Waiter.wait_for_ajax
#
#   if fields.headers.length == 3
#     current_within = within
#
#     rows = fields.rows.unshift(fields.headers)
#
#     rows.each do |(within, label, value)|
#       case within
#       when /\A(.+?)(?: "(.*)")?\Z/
#         current_within = Pickles.detect_node($1, $2, within)
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
#       CheckIn::Factory.new(label, value, within: current_within).call.call
#     end
#   elsif fields.headers.length == 2
#     fields.rows_hash.each do |label, value|
#       pry binding if label['pry']
#       CheckIn::Factory.new(label, value, within: within).call.call
#     end
#   else
#     raise(ArgumentError, 'Unsupported table type. Must contain 2 or 3 columns')
#   end
#
# end
