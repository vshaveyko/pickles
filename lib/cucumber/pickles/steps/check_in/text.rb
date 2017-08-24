class CheckIn::Text

  include RSpec::Expectations
  include RSpec::Matchers

  def initialize(label, value, within)
    @label = label
    @value = value
    @within = within || Capybara.current_session
  end

  def call
    expect(@within).to have_content(@value)
    expect(@within).to have_content(@label)
  end

end
