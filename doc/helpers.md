### Capybara test helpers

Bunch of usefull helpers for everyday testing with capybara.

Mostly usefull if you're building a SPA app or just have tons of javascript and standard Capybara helper methods isnt enough.

#### Start with:
 ```rb
 require 'pickles/helpers'
 ```

 If you're using cucumber you may want to:
 ```rb
 World(Pickles)
 ```

 Or you can use it through:
 ```rb
 Pickles.helper_name
 ```

#### Configure ( these are the defaults )

```rb
Pickles.configure do |c|

  #
  # Usually referring to elements on page as .some-css-class is a bad practice.
  #
  # You can provide a map with aliases pointing to that stuff in this config 
  #   Ex: c.css_node_map = { some_block: '.some-css-class' }
  #
  # And refer to it across within blocks in every predefined step or by manually using detect_node_helper
  # 
  c.css_node_map = {} 
  # Same as above but shouled be aliased to xpath selector
  c.xpath_node_map = {} 

  #
  # Log xhr error response to browser console, 
  # 
  # You can configure capybara to log this to your console: ( For example if example failed )
  #
  # puts page.driver.browser.manage.logs.get('browser').select { |log| log.level == 'SEVERE' }.map(&:message).map(&:red)
  #
  c.log_xhr_response = false 
  
  # 
  # In some table steps you can provide '(...)' identifier to override how that step should be handled
  # 
  # See 'I fill in the following:' for explaination
  #
  c.fill_tag_steps_map = { 'select' => Select }

  #
  # Same as above for 'fields are filled with:' step
  #
  c.check_tag_steps_map = { 'text' => Text }

end
```

#### Helpers Index:

#####  Locator string: `"=Text[2]"`:
  + 'Text' - required - text to look up by
  + '='    - optional - lookup exact text in node if given
  + '[2]'  - optional - index of element on page. If found 4 elements than 3rd will be selected - indexed from 0. 

##### find_node(locator, within: nil)
  
  Find node on page by [Locator string](#locator-string-text2-)

  within - capybara node to limit lookup

  returns: capybara node

##### find_input(locator, within: nil)

  Find inputtable node on page by [Locator string](#locator-string-text2-)

  inputtable means: `input | textarea | [contenteditable]`

#### detect_node(el_alias, locator = nil, within: nil)

  Does lookup based on provided in config maps

  if within.present? => limit search to within
  if locator.present? => use locator in step location

  Use el_alias to find needed xpath / css in maps provided to config.
  Priority xpath_map => css_map => el_alias as it is

  locator and el_alias can use index configuration from [Locator string](#locator-string-text2-)

##### wait_for_ajax
  
  Waits for ajax requests to end before proceeding further.
  Terminated with `Capybara::ElementNotFound` after `Capybara.default_wait_time` seconds

##### blur(node)
  
  Triggers *node* blur event and clicks on body to perform blur

##### select_input(input, value = nil)

  Selects *input*[type="checkbox"] OR *input*[type="radio"] on form

  Triggers click after selection to trigger javascript events ( may change in future )

##### attach_file(input, file_name)

  Attaches file with *file_name* to *input*[type="file"]

  *file_name* is fetched from `features/support/attachments/*file_name*` and raises RuntimeError if file not found
