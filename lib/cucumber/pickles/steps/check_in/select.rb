class CheckIn::Select

  include RSpec::Expectations
  include RSpec::Matchers

  def initialize(label, value, within)
    @label = label
    @value = value
    @within = within || Capybara.current_session
  end

  def call
    locator, wait  = Locator::Wait.execute(@label)

    options = { selected: @value }
    options[:wait] = wait if wait

    expect(@within).to have_select(locator, options)
  end

end
