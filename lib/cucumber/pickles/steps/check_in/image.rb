class CheckIn::Image

  include RSpec::Expectations
  include RSpec::Matchers

  def initialize(label = nil, value, within)
    @label = label
    @value = value
    @within = within || Capybara.current_session
  end

  def call(is_not = false)
    if is_not
      expect(@within).not_to have_selector("img[src*='#@value']")
    else
      expect(@within).to have_selector("img[src*='#@value']")
    end
  end

end
