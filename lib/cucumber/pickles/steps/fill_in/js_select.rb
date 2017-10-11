class FillIN::JsSelect

  def initialize(label, value, within)
    @label = label
    @value = value
    @within = within || Capybara.current_session
  end

  def call
    locator, index = Locator::Index.execute(@value)
    locator, xpath = Locator::Equal.execute(locator)

    index ||= 1

    input = FillIN::Input.new(@label, locator, @within).call

    Waiter.wait do
      # prev version "(./ancestor::*[#{xpath}][#{index}]/#{xpath})[#{index}]"
      input.find(:xpath, "(./ancestor::*[#{xpath}]/#{xpath})[#{index}]").click
    end

    Pickles.blur(input)

    Waiter.wait_for_ajax

    input
  end

  private

  attr_reader :label, :value

end
