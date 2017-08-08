class Steps::Select < Steps::Common

  #
  # @value = value to select
  # @label = selector label to find
  #
  def invoke(value, label)
    select(value, from: label)

    true
  end

end
