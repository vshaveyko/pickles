def test_input(input_holder, value)
  expect(input_holder.find('input', wait: 0).value.strip).to eq value.strip
rescue Capybara::ElementNotFound
  nil
end

def test_date(input_holder, value)
  date_container = input_holder.find('.form-input.mod-custom', wait: 0)
  # date and time
  date_container.text == value || date_container.find_all('input').map(&:value).join(':') == value
rescue Capybara::ElementNotFound
  nil
end

def test_textarea(input_holder, value)
  expect(input_holder.find('textarea', wait: 0).value).to eq value
rescue Capybara::ElementNotFound
  nil
end

def test_placeholder(placeholder, value, _index)
  expect(find("input[placeholder='#{placeholder}']", match: :prefer_exact).value).to eq value
rescue Capybara::ElementNotFound
  nil
end

def test_complex_input(input_holder, values)
  values = values.split(':')
  input_holder.all('input', wait: 0).zip(values).compact.each { |input, value| expect(input.value.strip).to eq value.to_s.strip }
rescue Capybara::ElementNotFound,
       RSpec::Expectations::ExpectationNotMetError
  nil
end

def test_checkbox(label, value, _index)
  checkbox_item = find('.form-checkbox-item', text: label, wait: 0, match: :prefer_exact).find('input', visible: false, wait: 0)

  if value
    expect(checkbox_item).to be_selected
  else
    expect(checkbox_item).not_to be_selected
  end
rescue Capybara::ElementNotFound
  nil
end

def test_radio(label, value, _index)
  radio_item = find('.form-radio-item', text: label, wait: 0, match: :prefer_exact).find('input', visible: false, wait: 0)

  if value
    expect(radio_item).to be_selected
  else
    expect(radio_item).not_to be_selected
  end
rescue Capybara::ElementNotFound
  nil
end

def find_input_holder(label, index)
  if index
    all(selector_by_alias(:input_holder), text: label)[index]
  else
    find(selector_by_alias(:input_holder), text: label, match: :prefer_exact)
  end
rescue Capybara::ElementNotFound
  nil
end

And(/^I can see entered values( within (?:.*))?$/) do |within_block, table|
  is_index_reg = /(.*)?\[(.*)\]/

  table.rows_hash.each do |selector, value|
    node = find_node(selector, within: within_block)

    value = parse_value(value)

    if value == true || value == false
      next test_checkbox(label, value, index) || test_radio(label, value, index) || raise(Capybara::ElementNotFound, "label: #{selector}")
    end

    input_holder = find_input_holder(label, index)

    if input_holder
      test_complex_input(input_holder, value) ||
        test_input(input_holder, value) ||
        test_date(input_holder, value) ||
        test_textarea(input_holder, value) ||
        raise(Capybara::ElementNotFound, "label: #{label}")
    else
      test_placeholder(label, value, index) || raise(Capybara::ElementNotFound, "label: #{label}")
    end
  end
end
