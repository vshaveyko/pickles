# Pickles

This gem contains some helpers to simplify testing with capybara along with afew predefined cucumber steps.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pickles'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pickles

# Usage

## Supported cucumber steps:

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
