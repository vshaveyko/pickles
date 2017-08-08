class Steps::Input < Steps::Common

  def invoke(label ,value)
    find_input(label, within_block: page).set(value)
  end

end
