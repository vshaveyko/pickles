class Steps::Common

  def initialize(page)
    @page = page
  end

  #
  # returns
  #   boolean - whether performed successfully
  #
  def invoke(*)
    false
  end

  private

  attr_reader :page

end
