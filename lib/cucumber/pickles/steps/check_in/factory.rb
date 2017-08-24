class CheckIn::Factory

  TAG = /^(.+\S+)\s*\((.*)\)$/

  def initialize(label, value, within: nil)
    @label = label
    @value = value
    @within = within
  end

  def call
    if !@value.nil? && @value[':']
      step = CheckIn::ComplexInput
      # return if text_complex_input(label, value, within)
    elsif @label =~ TAG
      @label = $1
      tag = $2
      step = Pickles.config.check_step_by_tag(tag) || CheckIn::Input
    else
      step = CheckIn::Input
    end

    step.new(@label, @value, @within)
  end

end
