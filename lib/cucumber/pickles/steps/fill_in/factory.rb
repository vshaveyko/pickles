class FillIN::Factory

  TAG = /^(.+\S+)\s*(\(.*\))$/

  def initialize(label, value, within_block: nil)
    @label = label
    @value = value
    @within_block = within_block
  end

  def call
    if @value[':']
      step = FillIN::ComplexInput
    elsif @label =~ TAG
      @label = $1
      tag = $2
      step = Pickles.config.step_by_tag(tag) || FillIN::Input
    else
      step = FillIN::Input
    end

    step.new(@label, @value, @within_block).call
  end

end
