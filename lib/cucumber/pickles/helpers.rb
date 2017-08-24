unless defined?(SUPPORT_DIR)
  in_features_dir = caller.select { |path| path =~ /features/ }.first

  if in_features_dir
    features_dir = in_features_dir.split('/')

    2.times { features_dir.pop }

    SUPPORT_DIR = File.join(features_dir,'support')
  end
end

require_relative 'refinements'
require_relative 'config'
require_relative 'errors/ambigious'

module Locator

  _dir = 'cucumber/pickles/locator/'

  autoload :Index, _dir + 'index'
  autoload :Equal, _dir + 'equal'

end

module Helpers

  _dir = 'cucumber/pickles/helpers/'

  autoload :Main, _dir + 'main'
  autoload :Regex, _dir + 'regex'

end

module Pickles

  extend  Helpers::Main
  include Helpers::Main

end
