require 'spec_helper'

require 'cucumber/pickles/artifact'

RSpec.describe "#Artifact::Index" do

  it 'returns correct index xpath with index' do
    locator, index_xpath = Artifact::Index.execute('locator[1]', '')

    expect(index_xpath).to eq '[1]'
    expect(locator).to eq 'locator'
  end

  it 'returns empty without index' do
    locator, index_xpath = Artifact::Index.execute('locator', '')

    expect(index_xpath).to eq ''
    expect(locator).to eq 'locator'
  end

end
