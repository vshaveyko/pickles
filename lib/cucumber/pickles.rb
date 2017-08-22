unless defined?(SUPPORT_DIR)
  in_features_dir = caller.select { |path| path =~ /features/ }.first

  if in_features_dir
    features_dir = in_features_dir.split('/')

    2.times { features_dir.pop }

    SUPPORT_DIR = File.join(features_dir,'support')
  end
end

require_relative 'pickles/helpers'

# :nodoc:
module Pickles

  extend Helpers::Main

end

require 'cucumber/pickles/config'

# errors
require_relative 'pickles/errors/index_node_not_found'

# cucumber transforms
require 'cucumber/pickles/within_transform'

require_relative 'pickles/fill_in'
require_relative 'pickles/check_in'

# cucumber steps
require 'cucumber/pickles/form/fill'
require 'cucumber/pickles/form/can_see'
require 'cucumber/pickles/form/check'

require 'cucumber/pickles/location_steps'
require 'cucumber/pickles/navigation_steps'

# helpers
require 'cucumber/pickles/helpers/waiter'
require 'cucumber/pickles/helpers/node_text_lookup'
