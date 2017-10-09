When 'I go back' do
  page.evaluate_script('history.back()')
end

And(/^visit "(.*)"$/) do |url|
  visit url

  Waiter.wait_for_ajax
end
