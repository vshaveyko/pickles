class Pickles::FillIn

  SELECT_TAG =      /^(.+\S+)\s*(?:\(select\))$/
  CONTENTEDITABLE = /^(.+\S+)\s*(?:\(contenteditable\))$/

  class << self
    include Pickles

    def invoke(label, value, within_block = nil, is_select: false)
      within_block ||= Capybara.current_session

      if label =~ SELECT_TAG
        label = $1
        is_select = true
      end

      if label =~ CONTENTEDITABLE
        label = $1
        is_contenteditable = true
      end

      return _handle_contenteditable(within_block, label, value) if is_contenteditable

      input = find_input(label, within_block: within_block)

      case input.native.attribute("type")

      when "radio", "checkbox"
        pickles_select_input(input, value)
      when "file"
        pickles_attach_file(input, value)
      else
        input.set(value)
      end


      _handle_select(within_block, label, value)          if is_select
      _trigger_blur_event(input)
    end

    private

    def _handle_select(page, label, value)
      pry binding if label == 'Allergy'
      Waiter.wait do
        page.find(:xpath,
          ".//*[contains(., '#{label}')][not(*[contains(., '#{label}')])]" \
          "/ancestor::*[.//*[.='#{value}'][not(*[.='#{value}'])]][1]" \
          "//*[.='#{value}'][not(*[.='#{value}'])]"
        ).click
      end
    end

    def _handle_contenteditable(page, label, value)
      page.find(:xpath, "//*[@placeholder='#{label}']").set(value)
    end

    def _trigger_blur_event(input)
      blur(input)
    end


  end

end
