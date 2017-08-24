require 'spec_helper'

module Locator; end
require 'cucumber/pickles/locator/index'
require 'cucumber/pickles/locator/equal'

RSpec.describe "#Locator" do

  describe "#Index" do

    it 'returns correct index xpath with index' do
      locator, index = Locator::Index.execute('locator[1]')

      expect(index).to eq 1
      expect(locator).to eq 'locator'
    end

    it 'returns empty without index' do
      locator, index = Locator::Index.execute('locator')

      expect(index).to be_nil
      expect(locator).to eq 'locator'
    end

  end

  describe "#Equal" do
    # ???
  end

end
