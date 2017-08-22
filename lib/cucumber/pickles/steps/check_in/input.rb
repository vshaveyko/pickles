class CheckIn::Input

  include RSpec::Expectations
  include RSpec::Matchers

  def initialize(label, value, within_block)
    @label = label
    @value = value
    @within_block = within_block || Capybara.current_session
  end

  def call
    case input.native.attribute("type")

    when "text"
      expect(input.value).to eq @value
    when "radio", "checkbox"
      case @value

      when "true", true
        expect(input).to be_selected
      when "false", false, nil
        expect(input).not_to be_selected
      end
    when "file"
      expect(page).to have_selector("[src$='#{@value}']")
    end
  end

  private

  def input
    @input ||= Pickles.find_input(@label, within_block: @within_block)
  end

end
