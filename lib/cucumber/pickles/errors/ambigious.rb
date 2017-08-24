class Pickles::Ambiguous < StandardError

  def initialize(locator, within, search_params, message)
    @search_params= search_params
    @within = within
    @locator = locator
    @message = message.to_s
  end

  def message
    "Ambiguous(locator: #{@locator}, count: #{_nodes.count}" \
      + (@message != "" ? ", message: #@message" : "") \
      + (@within.respond_to?(:path) ? "\n within: #{@within.path}" : "") \
       + "): \n#{_inspect_nodes}"
  end

  private

  def _inspect_nodes
    _nodes.map(&:inspect).join("\n")
  end

  def _nodes
    @nodes ||= @within.all(*@search_params)
  end

end
