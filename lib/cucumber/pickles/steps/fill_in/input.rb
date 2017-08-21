class FillIN::Input

  include Pickles

  def initialize(label, value, within_block)
    @label = label
    @value = value
    @within_block = within_block || Capybara.current_session
  end

  def call
    case input.native.attribute("type")

    when "radio", "checkbox"
      pickles_select_input(input, @value)
    when "file"
      pickles_attach_file(input, @value)
    else
      input.set(@value)

    end

    input
  end

  private

  def input
    @input ||= find_input(@label, within_block: @within_block)
  end

end
