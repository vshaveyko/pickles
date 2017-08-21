require 'spec_helper'

RSpec.describe '#FillIN::Factory' do

  class NewCoolStep
    def call
    end
  end

  before(:suite) do
    Pickles.configure do |config|
      config.fill_tag_steps_map = {
        new_cool_step: NewCoolStep
      }
    end
  end

  it 'uses custom step if label demands it' do
    label = "input (new_cool_step)"

    step = FillIN::Factory.new(label, nil).call

    expect(step).to be_instance_of(FillIN::Input)
  end

  it 'uses input step if custom step required but not defined' do
    label = "input (another_cool_step)"

    step = FillIN::Factory.new(label, nil).call

    expect(step).to be_instance_of(NewCoolStep)
  end

  it 'uses complex input step if value has :' do
    label = "input (new_cool_step)"
    value = "1:2:3"

    step = FillIN::Factory.new(label, value).call

    expect(step).to be_instance_of(FillIN::ComplexInput)
  end

  it 'uses input step by default' do
    label = "input"
    value = "1"

    step = FillIN::Factory.new(label, value).call

    expect(step).to be_instance_of(FillIN::Input)
  end

end
