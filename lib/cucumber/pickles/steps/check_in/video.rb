class CheckIn::Video

  include RSpec::Expectations
  include RSpec::Matchers

  def initialize(label = nil, value, within)
    @label = label
    @value = value
    @within = within || Capybara.current_session
  end

  def call(is_not)
    if is_not
      expect(@within).not_to have_selector("iframe[src*=#@value]")
    else
      expect(@within).to have_selector("iframe[src*=#@value]")
    end
  end

end
