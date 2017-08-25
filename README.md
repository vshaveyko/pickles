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

  1. 
      ```rb  
      When I (?:click|navigate) "([^"]*)"( within (?:.*))? 
      ```

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

  2. 
     ```rb 
     I (?:click|navigate):( within (?:.*))?
     ```

     ##### Examples:
       ```rb
       I navigate:
         | click | My button   |
         | hover | My span     |
         | hover | Your span   |
         | click | Your button |
       ```

     ##### Description:
       + alias for previous, but accepts table as argument to allow multiple arguments.
       + note ':' in definition
       + for within checkout docs


+ Forms:
  + Fill:
     1. 
        ```rb 
        When (?:|I )fill in the following:( within (?:.*))?
        ```

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
           + Add custom (...) block for second column to define your own form fill steps
             supported by default:
               (select) - uses 'I select ".." from ".."' under the hood. Check it out

     2.  
         ```rb
         When (?:|I ) select "([^"]*)" from "([^"]*)"( within (?:.*))?
         ```

         ##### Examples:
           ```rb
            When I select "Male" from "sex" within "User data"
           ```

         ##### Description:
           + Fills javascript-like custom selectors(inputs with blocks)
           + Params:
             1. value to select identifier for block with select result( see [find_node](#find_nodelocator-within-nil) ) 
             2. field identifier ( used by [find_node](#find_nodelocator-within-nil) )
             3. within block identifier
     3.  
         ```rb
         When (?:|I )(?:select|unselect) "([^"]*)"( within (?:.*))?
         ```

         ##### Examples:
           ```rb
            When I select "Male" within "User data"
           ```

         ##### Description:
           + Fills checkboxes/radio buttons
           + Params:
             1. identifier for block with selected select ( see [find_node](#find_nodelocator-within-nil) ) 
     4.  
         ```rb
         When (?:|I )attach the file "([^"]*)" to "([^"]*)"( within (?:.*))?
         ```

         ##### Examples:
           ```rb
            When I attach the file "test.png" to "Avatar" within "User data"
           ```

         ##### Description:
           + Attaches given file to identified fields
           + Params:
             1. relative file name. see attach_file
             2. file input identifier. see [find_node](#find_nodelocator-within-nil)
             3. within block identifier. see [find_node](#find_nodelocator-within-nil)
            
     5.  
         ```rb
         When (?:|I )(?:fill|select|unselect)(select)?(?: "([^"]*)")?(?: with "([^"]*)")?( within (?:.*))?
         ```

         ##### Examples:
           ```rb
            When I fill "Name" with "Peter" within "User data"
            When I fill "Avatar" with "test.png" within "User data"
            When I fill "Male" within "User data"
            When I fill "sex" with "Male" within "User data"
           ```

         ##### Description:
           + Tries to fill data by guessing field type from found input type(text|checkbox|radio|etc)
           + There MUST always be an input identified by identifier
       
 + Check
   1.  
       ```rb
       Then fields are filled with:( within (?:.*))?
       ```

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
         + Check fields filled by 'I fill in the folllwing'
         + Supports exact same table syntax and optional column

## Development


## Contributing

     Bug reports and pull requests are welcome on GitHub at https://github.com/vshaveyko/pickles.


## License

     The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
