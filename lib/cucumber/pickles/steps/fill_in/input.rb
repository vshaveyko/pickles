class FillIN::Input

  def initialize(label, value, within_block)
    @label = label
    @value = value
    @within_block = within_block || Capybara.current_session
  end

  def call
    case input.native.attribute("type")

    when "radio", "checkbox"
      Pickles.pickles_select_input(input, @value)
    when "file"
      Pickles.pickles_attach_file(input, @value)
    else # password email tel ...
      input.set(@value)

    end

    input
  end

  private

  def input
    @input ||= Pickles.find_input(@label, within_block: @within_block)
  end

end
