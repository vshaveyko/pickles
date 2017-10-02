require 'spec_helper'

require 'cucumber/pickles/helpers/waiter'

RSpec.describe '#Waiter' do

  it 'Return 0 pending requests on page load' do
    @session.visit('/with_js')

    expect(Waiter.pending_ajax_requests_num).to eq 0
  end

  it 'Return 1 pending requests with open request' do
    @session.visit('/with_js')

    @session.evaluate_script(
      <<~JS
        new XMLHttpRequest().open("GET", '')
        new XMLHttpRequest().send()
      JS
    )

    expect(Waiter.pending_ajax_requests_num).to eq 1
  end

  it 'Return 0 pending requests with closed request' do
    @session.visit('/with_js')

    @session.evaluate_script("window.req = new XMLHttpRequest();")

    @session.evaluate_script("window.req.open('GET', '', true);")

    expect(Waiter.pending_ajax_requests_num).to eq 1

    @session.evaluate_script("window.req.send();")

    @session.evaluate_script("window.req.abort();")

    expect(Waiter.pending_ajax_requests_num).to eq 0
  end

end
