require 'spec_helper'

require 'cucumber/pickles/fill_in'

RSpec.describe '#FillIN::Factory' do

  class NewCoolStep
    def initialize(*); end
  end

  Pickles.configure do |config|
    config.fill_tag_steps_map = {
      'new_cool_step' => NewCoolStep
    }
  end

  it 'uses custom step if label demands it' do
    label = "input (new_cool_step)"

    step = FillIN::Factory.new(label, nil).call

    expect(step).to be_instance_of(NewCoolStep)
  end

  it 'uses input step if custom step required but not defined' do
    label = "input (another_cool_step)"

    step = FillIN::Factory.new(label, nil).call

    expect(step).to be_instance_of(FillIN::Input)
  end

  it 'uses complex input step if value has :' do
    label = "input (new_cool_step)"
    value = "1:2:3"

    step = FillIN::Factory.new(label, value).call

    expect(step).to be_instance_of(FillIN::ComplexInput)
  end

  it 'uses default input step if value has : and surrounded by quotes' do
    label = "input"
    value = "\"1:2:3\""

    step = FillIN::Factory.new(label, value).call

    expect(step).to be_instance_of(FillIN::Input)
    expect(step.value).to eq "1:2:3"
  end

  it 'uses input step by default' do
    label = "input"
    value = "1"

    step = FillIN::Factory.new(label, value).call

    expect(step).to be_instance_of(FillIN::Input)
  end

end
