require 'spec_helper'

RSpec.describe '#CheckIn::Factory' do

  class NewCoolStep
    def call
    end
  end

  before(:suite) do
    Pickles.configure do |config|
      config.check_tag_steps_map = {
        new_cool_step: NewCoolStep
      }
    end
  end

  it 'uses custom step if label demands it' do
    label = "input (new_cool_step)"

    step = CheckIn::Factory.new(label, nil).call

    expect(step).to be_instance_of(CheckIn::Input)
  end

  it 'uses input step if custom step required but not defined' do
    label = "input (another_cool_step)"

    step = CheckIn::Factory.new(label, nil).call

    expect(step).to be_instance_of(NewCoolStep)
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
