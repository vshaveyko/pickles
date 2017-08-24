class FillIN::Input

  def initialize(label, value, within)
    @label = label
    @value = value
    @within = within || Capybara.current_session
  end

  def call
    case input.native.attribute("type")

    when "radio", "checkbox"
      Pickles.select_input(input, @value)
    when "file"
      Pickles.attach_file(input, @value)
    else # password email tel ...
      input.set(@value)
    end

    input
  end

  private

  def input
    @input ||= Pickles.find_input(@label, within: @within)
  end

end
