# When /^select "(.*)" from "(.*)"$/ do |value, label|
#   select value, from: label
# end

class FillIN::Select

  def initialize(label, value, within)
    @label = label
    @value = value
    @within = within || Capybara.current_session
  end

  def call
    locator, wait  = Locator::Wait.execute(@label)
    locator, index = Locator::Index.execute(locator)

    options = { from: locator }
    options[:wait] = wait if wait

    @within.select @value, options
  end

  private

  attr_reader :label, :value

end
