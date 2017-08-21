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

  if fields.headers.length == 3
    current_within = within_block

    rows = fields.rows.unshift(fields.headers)

    rows.each do |(within, label, value)|
      case within
      when /\A(.+?)(?: "(.*)")?\Z/
        current_within = detect_node($1, $2, within_block)
      when "-"
        current_within = within_block
      end

      CheckIn::Factory.new(label, value, current_within).call.call
    end
  elsif fields.headers.length == 2
    fields.rows_hash.each do |label, value|
      CheckIn::Factory.new(label, value, within_block).call.call
    end
  else
    raise(ArgumentError, 'Unsupported table type. Must contain 2 or 3 columns')
  end

end
