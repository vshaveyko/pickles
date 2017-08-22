require 'spec_helper'

require 'cucumber/pickles/fill_in'
require 'cucumber/pickles/check_in'

RSpec.describe '#CheckIn::Factory' do

  class NewCoolStep
    def initialize(*); end
  end

  Pickles.configure do |config|
    config.check_tag_steps_map = {
      'new_cool_step' => NewCoolStep
    }
  end

  it 'uses custom step if label demands it' do
    label = "input (new_cool_step)"

    step = CheckIn::Factory.new(label, nil).call

    expect(step).to be_instance_of(NewCoolStep)
  end

  it 'uses input step if custom step required but not defined' do
    label = "input (another_cool_step)"

    step = CheckIn::Factory.new(label, nil).call

    expect(step).to be_instance_of(CheckIn::Input)
  end

  it 'uses complex input step if value has :' do
    label = "input (new_cool_step)"
    value = "1:2:3"

    step = CheckIn::Factory.new(label, value).call

    expect(step).to be_instance_of(CheckIn::ComplexInput)
  end

  it 'uses input step by default' do
    label = "input"
    value = "1"

    step = CheckIn::Factory.new(label, value).call

    expect(step).to be_instance_of(CheckIn::Input)
  end

end
