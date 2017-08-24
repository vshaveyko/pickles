class FillIN::Select

  def initialize(label, value, within)
    @label = label
    @value = value
    @within = within || Capybara.current_session
  end

  def call
    input = FillIN::Input.new(@label, @value, @within).call

    text, selector = NodeTextLookup.lookup_values(value)
    item_xpath = selector.(text)

    Waiter.wait do
      input.find(:xpath, "./ancestor::*[#{item_xpath}][1]/#{item_xpath}").click
    end

    Pickles.blur(input)

    Waiter.wait_for_ajax

    input
  end

  private

  attr_reader :label, :value

end
