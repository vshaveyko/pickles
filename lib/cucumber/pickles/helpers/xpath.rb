class Pickles::XPath

  EXPRESSIONS = {
    text_equal: ->(text) { ".//*[text()='#{text}'" },
    text_last_container: -> (text) {  ".//*[contains(., '#{text}')][not(*[contains(., '#{text}')])]" },
    input_by_closest_label: -> (label) {
      "//*[contains(text(),'#{label}')]/ancestor::*[.//input and position() = 1]//input"
    }

  }.freeze

  class << self

    def [](alias)
      EXPRESSIONS[alias.to_sym]
    end

  end

end
