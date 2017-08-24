$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

require 'capybara'
require 'capybara/dsl'

require 'pry'

require 'capybara/spec/test_app'

require 'selenium-webdriver'
require 'cucumber/pickles/helpers'

Capybara.register_driver :selenium_chrome_clear_storage do |app|
  chrome_options = {
    browser: :chrome,
    options: ::Selenium::WebDriver::Chrome::Options.new.tap { |options| options.args << 'headless' },
    clear_local_storage: true,
    clear_session_storage: true,
  }

  Capybara::Selenium::Driver.new(app, chrome_options)
end

Capybara.app = TestApp

Capybara.javascript_driver = Capybara.current_driver = :selenium_chrome_clear_storage

RSpec.configure do |config|
  config.before(:all) do
    @session = Capybara.current_session
  end
end
