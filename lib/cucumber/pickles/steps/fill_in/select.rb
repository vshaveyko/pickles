class FillIN::Select

  include Pickles

  def initialize(label, value, within_block)
    @label = label
    @value = value
    @within_block = within_block || Capybara.current_session
  end

  def call
    input = FillIN::Input.new(@label, @value, @within_block).call

    _select_item

    blur(input)
  end

  private

  attr_reader :label, :value

  def _select_item
    Waiter.wait do
      page.find(:xpath,
        ".//*[contains(., '#{label}')][not(*[contains(., '#{label}')])]" \
        "/ancestor::*[.//*[.='#{value}'][not(*[.='#{value}'])]][1]" \
        "//*[.='#{value}'][not(*[.='#{value}'])]"
      ).click
    end
  end

end
