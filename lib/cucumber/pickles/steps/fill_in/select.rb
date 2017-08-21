class FillIN::Select

  include Pickles

  def initialize(label, value, within_block)
    @label = label
    @value = value
    @within_block = within_block || Capybara.current_session
  end

  def call
    input = FillIN::Input.new(@label, @value, @within_block).call

    text, selector = NodeTextLookup.lookup_values(value)
    item_xpath = selector.(text)

    Waiter.wait do
      input.find(:xpath, "./ancestor::*[#{item_xpath}][1]/#{item_xpath}").click
    end

    blur(input)
  end

  private

  attr_reader :label, :value

end
