class Steps::Attach < Steps::Common

  def invoke(label, value)
    input = find_input(label, within_block: page)

    pickles_attach_file(input, value)
  end

end
