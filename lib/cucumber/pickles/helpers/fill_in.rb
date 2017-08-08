class Pickles::FillIn

  SELECT_TAG = /^(.+\S+)\s*(?:\(select\))$/

  class << self
    include Pickles

    def invoke(label, value, within_block = nil, is_select: false)
      within_block ||= Capybara.current_session

      if label =~ SELECT_TAG
        label = $1
        is_select = true
      end

      input = find_input(label, within_block: within_block)

      case input.native.attribute("type")

      when "text"
        input.set(value)
      when "radio", "checkbox"
        pickles_select_input(input, value)
      when "file"
        pickles_attach_file(input, value)
      end

      _handle_select(within_block, label, value) if is_select

      _trigger_blur_event(input)
    end

    private

    def _handle_select(page, label, value)
      Waiter.wait do
        page.find(:xpath,
          ".//*[contains(., '#{label}')][not(*[contains(., '#{label}')])]" \
          "/ancestor::*[.//*[.='#{value}'][not(*[.='#{value}'])]][1]" \
          "//*[.='#{value}'][not(*[.='#{value}'])]"
        ).click
      end
    end

    def _trigger_blur_event(input)
      blur(input)
    end


  end

end
