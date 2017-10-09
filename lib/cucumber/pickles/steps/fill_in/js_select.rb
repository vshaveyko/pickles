class FillIN::JsSelect

  def initialize(label, value, within)
    @label = label
    @value = value
    @within = within || Capybara.current_session
  end

  def call
    input = FillIN::Input.new(@label, @value, @within).call

    locator, index = Locator::Index.execute(@value)
    locator, xpath = Locator::Equal.execute(locator)

    index ||= 1

    Waiter.wait do
      input.find(:xpath, "./ancestor::*[#{xpath}][#{index}]/#{xpath}").click
    end

    Pickles.blur(input)

    Waiter.wait_for_ajax

    input
  end

  private

  attr_reader :label, :value

end
