# cucumber transforms
_folder = 'cucumber/pickles/'

require _folder + 'transform'
require _folder + 'fill_in'
require _folder + 'check_in'

_steps_folder = _folder + 'steps/'

module Pickles::StepDef

  module_function

  def define_table_step(allowed_table_cols)
    -> ( within, table ) do

      Waiter.wait_for_ajax

      if table.headers.length == 3 && 3.in?(allowed_table_cols)
        current_within = within

        rows = table.rows.unshift(table.headers)

        rows.each do |(within, label, value)|
          case within
          when Helpers::Regex::WITHIN
            current_within = Pickles.detect_node($1, $2, within: within)
          when "-"
            current_within = within
          end

          if label['pry']
            label['pry'] = ''

            pry binding
          end

          yield(label, value, current_within)
        end
      elsif table.headers.length == 2 && 2.in?(allowed_table_cols)
        table.rows_hash.each do |label, value|
          if label['pry']
            label['pry'] = ''

            pry binding
          end

          yield(label, value, within)
        end
      elsif table.headers.length == 1 && 1.in?(allowed_table_cols)
        table.each do |label|
          if label['pry']
            label['pry'] = ''

            pry binding
          end

          yield(label, nil, within)
        end
      else
        raise(ArgumentError, "Unsupported table format. Must contain #{allowed_table_cols.join(' || ')} cols")
      end

    end
  end

end

require _steps_folder + 'fill'
require _steps_folder + 'check'
require _steps_folder + 'can_see'
require _steps_folder + 'redirect'
require _steps_folder + 'click'
