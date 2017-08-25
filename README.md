# Pickles

This gem contains some helpers to simplify testing with capybara along with afew predefined cucumber steps.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pickles', require: false
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pickles

```rb
require 'cucumber/pickles/helpers' # require only helpers without steps
# or
require 'cucumber/pickles' # require everything alltogether
```

## Configure

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

### Capybara test helpers

Bunch of usefull helpers for everyday testing with capybara.

Mostly usefull if you're building a SPA app or just have tons of javascript and standard Capybara helper methods isnt enough.

#### Start with:
 If you're using cucumber you may want to:
 ```rb
 World(Pickles)
 ```

 Or you can use it through:
 ```rb
 Pickles.helper_name
 ```

#### Index:

+ [wait_for_ajax](#wait_for_ajax)

+ [Locator string](#locator-string-text2)
+ [find_node](#find_nodelocator-within-nil)
+ [detect_node](#detect_nodeel_alias-locator--nil-within-nil)
+ [find_input](#find_inputlocator-within-nil)
+ [blur](#blurnode)
+ [select_input](#select_inputinput-value--nil)
+ [attach_file](#attach_fileinput-file_name)

#####  Locator string: `Ex: "=Text[2]"`:
  + 'Text' - required - text to look up by
  + '='    - optional - lookup exact text in node if given
  + '[2]'  - optional - index of element on page. If found 4 elements than 3rd will be selected - indexed from 0. 

##### find_node(locator, within: nil)
  
  Find node on page by [Locator string](#locator-string-text2)

  within - capybara node to limit lookup

  returns: capybara node

##### find_input(locator, within: nil)

  Find inputtable node on page by [Locator string](#locator-string-text2)

  inputtable means: `input | textarea | [contenteditable]`

##### detect_node(el_alias, locator = nil, within: nil)

  Does lookup based on provided in config maps

  if within.present? => limit search to within
  if locator.present? => use locator in step location

  Use el_alias to find needed xpath / css in maps provided to config.
  Priority xpath_map => css_map => el_alias as it is

  locator and el_alias can use index configuration from [Locator string](#locator-string-text2)

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

### Supported cucumber steps:

+ Navigation 

  1.  `When I (?:click|navigate) "([^"]*)"( within (?:.*))?`

      ##### Examples:
      ```rb
      When I click "My button" # standard click by text

      When I click "=Mo" # click node that has exact this text. i.e. ignore: Monday, Moth
        
      When I click ">Mo" # ajax wait requests done before clicking
      When I click "Mo>" # ajax wait requests done after clicking
        
      When I click ">Mo>" # both of the above
        
      When I click "My button,=Mo" # chain clicks ( click My button then click exact Mo )

      When I click "My button->=Mo" # same as above (-> is for chaining sequential clicks)
        
      When I click "My button>->=Mo>" # click My button, ajax wait then click Mo

      When I navigate ... # alias

      ```

      ##### Description:
        + for within checkout docs

  2.  `When I (?:click|navigate):( within (?:.*))?`

     ##### Examples:
     ```rb
     When I navigate:
       | click | My button   |
       | hover | My span     |
       | hover | Your span   |
       | click | Your button |
         
     When I navigate: within form "User data"
       | click | Submit   |
     ```

     ##### Description:
     + Same as previous, but allows table as argument.
     + note ` : ` in the definition

+ Forms:
  + Fill:
     1. `When (?:|I )fill in the following:( within (?:.*))?`

        ##### Examples:
         ```rb
         When I fill in the following:
           |                 | Account Number       | 5002       |
           |                 | Expiry date          | 2009-11-01 |
           |                 | Note                 | Nice guy   |
           |                 | Wants Email?         |            |
           | User data       | Sex         (select) | Male       |
           |                 | Avatar               | avatar.png |
           |                 | Due date             | 12:35      |
           | Additional data | Accept user agrement | true       |
           |                 | Send me letters      | false      |
           |                 | radio 1              | true       |
         ```

         ##### Description:
           + Fills form fields identified by second column.
           + First column is optional and defines 'within block' - see docs for within
           + Add custom (...) block for second column to define your own form fill steps in `config.fill_tag_steps_map`
             supported by default:
               (select) - uses `When I select ".." with ".."` under the hood.
               Ex:
               ```rb
               class FillDatepicker

                 def initialize(label, value, within)
                   # label = 'Date of birth'
                   @label = label
                   # value = '23.12.1998'
                   @value = Date.parse(value)
                   # within = detect_node("form", "User profile", within: page)
                   @within = within
                 end
                 
                 def call
                    # implement datepicker selecting logic
                 end
               end

               Pickles.configure do |c|
                 c.fill_tag_steps_map = { datepicker: FillDatepicker }
               end

               When I fill in the following:
                 | form "User profile" | Date of birth (datepicker) | 23.12.1998 |
               ```


     2.  `When (?:|I )attach the file "([^"]*)" to "([^"]*)"( within (?:.*))?`

         ##### Examples:
           ```rb
            When I attach the file "test.png" to "Avatar" within "User data"
           ```

         ##### Description:
           + Attaches given file to identified fields
           + Params:
             1. `features/support/attachments/` + `file_name` is used to identify file
             2. Input identifier. see `find_input` helper for searching details
             3. within block identifier
          + within part is optional
            
     4.  `When (?:|I )(?:fill|select)(?: "([^"]*)")?(?: with "([^"]*)")?( within (?:.*))?`

         ##### Examples:
           ```rb
            When I fill "Name" with "Peter" within "User data" # input[type="text"]
            When I fill "Avatar" with "test.png" within "User data" # input[type="file"]

            When I fill "Male" within "User data" # input[type="checkbox"] || input[type="radio"]
            When I select "Male" 

            When I select "sex" with "Male" # selector

           ```

         ##### Description:
           + Tries to fill data by guessing field type from found input type(text|checkbox|radio|etc)
           + There MUST always be an input identified by identifier
           + within part is optional
       
 + Check

   `Then fields are filled with:( within (?:.*))?`

   ##### Examples: 
     ```rb
     Then fields are filled with:
       | Account Number       | 5002       |
       | Expiry date          | 2009-11-01 |
       | Note                 | Nice guy   |
       | Wants Email?         | true       |
       | Sex                  | Male       |
       | Accept user agrement | true       |
       | Send me letters      | false      |
       | radio 1              | true       |
       | Avatar               | avatar.png |
       | Due date             | 12:35      |
     ```

   ##### Description:
     + Check fields filled by `I fill in the folllwing`
     + Supports exact same table syntax and optional column

## Contributing

     Bug reports and pull requests are welcome on GitHub at https://github.com/vshaveyko/pickles.


## License

     The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
