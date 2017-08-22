$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

require 'capybara'
require 'capybara/dsl'

require 'pry'

require 'capybara/spec/test_app'

require 'selenium-webdriver'
require 'cucumber/pickles/config'

Capybara.register_driver :selenium_chrome_clear_storage do |app|
  chrome_options = {
    browser: :chrome,
    options: ::Selenium::WebDriver::Chrome::Options.new()
  }

  chrome_options[:options].args << 'headless'

  Capybara::Selenium::Driver.new(app, chrome_options.merge(clear_local_storage: true, clear_session_storage: true))
end

Capybara.app = TestApp
Capybara.current_driver = :selenium_chrome_clear_storage
Capybara.javascript_driver = :selenium_chrome_clear_storage

#
# Capybara.register_driver :rack_test do |app|
#   Capybara::RackTest::Driver.new(app, headers: { 'HTTP_USER_AGENT' => 'Capybara' })
# end

# def capybara_session
#   @capybara_session ||= Capybara::Session.new(:selenium_chrome_clear_storage, TestApp)
# end
RSpec.configure do |config|
  config.before(:all) do
    @session = Capybara.current_session
  end
end
