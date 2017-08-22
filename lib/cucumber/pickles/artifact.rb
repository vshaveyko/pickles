module Artifact

  _dir = 'cucumber/pickles/artifact/'

  autoload :Index, _dir + 'index'

  # PLACEHOLDER = "---xpath-placeholder---"
  #
  # module_function
  #
  # def all_artifacts
  #   [
  #     Artifact::Index
  #   ]
  # end
  #
  # def apply(text, xpath, artifacts: all_artifacts)
  #   with_applyed_artifacts = artifacts.reduce(PLACEHOLDER) do |prev_reduced, artifact|
  #     text, xpath_with_artifact = artifact.execute(text, prev_reduced)
  #
  #     xpath_with_artifact
  #   end
  #
  #   if xpath.responds_to?(:call)
  #     with_applyed_artifacts[PLACEHOLDER] = xpath.(text)
  #   elsif xpath.is_a?(String)
  #     with_applyed_artifacts[PLACEHOLDER] = xpath
  #   else
  #     raise ArgumentError, "Second argument to apply should be either callable or a string."
  #   end
  #
  #
  #   with_applyed_artifacts
  # end
  #

end
