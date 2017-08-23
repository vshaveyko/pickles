class CheckIn::Text

  include RSpec::Expectations
  include RSpec::Matchers

  def initialize(label, value, within_block)
    @label = label
    @value = value
    @within_block = within_block || Capybara.current_session
  end

  def call
    expect(@within_block).to have_content(@value)
    expect(@within_block).to have_content(@label)
  end

end
