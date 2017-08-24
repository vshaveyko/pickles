class FillIN::Factory

  TAG = /^(.+\S+)\s*\((.*)\)$/

  def initialize(label, value, within: nil)
    @label = label
    @value = value
    @within = within
  end

  def call
    if !@value.nil? && @value[':']
      step = FillIN::ComplexInput
    elsif @label =~ TAG
      @label = $1
      tag = $2
      step = Pickles.config.step_by_tag(tag) || FillIN::Input
    else
      step = FillIN::Input
    end

    step.new(@label, @value, @within)
  end

end
