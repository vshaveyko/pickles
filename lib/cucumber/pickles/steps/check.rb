class Steps::Check < Steps::Common

  def invoke(label)
    input = find_input(label, within_block: page)

    pickles_select_input(input)
  end

end
