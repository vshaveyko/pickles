def wait_flags(text)
  if text.starts_with?('>')
    text = text[1..-1]

    Waiter.wait_for_ajax

    js_wait = true
  end

  if text.ends_with?('>')
    text = text.chomp('>')

    ajax_wait = true
  end

  [js_wait, text, ajax_wait]
end

def trigger(text, event, within)

  js_wait, text, ajax_wait = wait_flags(text)

  if js_wait
    Waiter.wait { Pickles.find_node(text, within: within).public_send(event) }
  else
    Pickles.find_node(text, within: within).public_send(event)
  end

  Waiter.wait_for_ajax if ajax_wait

end

#
# Use this to click anything anywhere:
#
# When I click "My button" - standard click by text
#
# When I click "=Mo" - click node that has exact this text. i.e. ignore: Monday, Moth
#
# When I click ">Mo" - ajax wait requests done before clicking
# When I click "Mo>" - ajax wait requests done after clicking
#
# When I click ">Mo>" - both of the above
#
# When I click "My button,=Mo" - chain clicks ( click My button then click exact Mo )
# When I click "My button->=Mo" - same as above (-> is for chaining sequential clicks)
#
# When I click "My button>->=Mo>" - click My button, ajax wait then click Mo
#
# etc.
#
When /^I (?:click|navigate) "([^"]*)"( within (?:.*))?$/ do |click_text, within|
  Waiter.wait_for_ajax

  click_text.split(/,|->/).each do |text|
    pry binding if text['pry']

    trigger(text, 'click', within)
  end

  Waiter.wait_for_ajax
end

#
# I navigate:
#   | click | My button   |
#   | hover | My span     |
#   | hover | Your span   |
#   | click | Your button |
#
When /^I (?:click|navigate):( within (?:.*))?$/ do |within, table|
  do_click = -> (event, text) do
    pry binding if text['pry']
    event = 'click' if event.strip.blank?

    trigger(text, event, within)
  end

  case table.headers.length
  when 1
    event = 'click'

    do_click = do_click.curry[event]

    table.raw.flatten.each(&do_click)
  when 2
    table.rows_hash.each(&do_click)
  else
    raise ArgumentError, "Unsupported table format"
  end

  Waiter.wait_for_ajax
end
