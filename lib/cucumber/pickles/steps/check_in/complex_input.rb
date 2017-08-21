class CheckIn::ComplexInput

  def initialize(label, value, within_block)
    @label = label
    @value = value
    @within_block = within_block || Capybara.current_session
  end

  def call
    @value.split(/\s*:\s*/).each.with_index do |value, index|
      input_locator = "#{label}[#{index}]"

      CheckIn::Input.new(input_locator, value, @within_block)
    end
  end

end
