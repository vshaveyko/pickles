class FillIN::Factory

  TAG = /^(.+\S+)\s*\((.*)\)$/

  def initialize(label, value, within: nil)
    @label = label
    @value = value
    @within = within
  end

  def call
    if in_quotes?
      remove_quotes!
    end

    if !@value.nil? && @value[':'] && !in_quotes?
      step = FillIN::ComplexInput
    elsif @label =~ TAG
      @label = $1
      tag    = $2
      step   = Pickles.config.step_by_tag(tag) || FillIN::Input
    else
      step = FillIN::Input
    end

    step.new(@label, @value, @within)
  end

private

  def in_quotes?
    @in_quotes ||= @value && @value[0] == "\"" && @value[-1] == "\""
  end

  def remove_quotes!
    @value[0]  = ''
    @value[-1] = ''
  end

end
