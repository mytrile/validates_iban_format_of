# validates_iban_format_of

Rails IBAN validator based on [iban-tools gem](https://github.com/alphasights/iban-tools)

# Installation

Add it to your Gemfile:

```ruby
gem 'validates_iban_format_of'
```

# Usage

## In ActiveRecord model

```ruby
# I18n locales are loaded automatically.

class BankAccount < ActiveRecord::Base
  validates_iban_format_of :iban, message_for_invalid: 'is not incorrect', message_for_missing: 'is blank'

  # OR
  # validates :iban, iban_format: { message_for_invalid: 'is not incorrect', message_for_missing: 'is blank' }
end
```

### In your model spec using RSpec:

```ruby
require "validates_iban_format_of/rspec_matcher"

describe Person do
  it { should validate_iban_format_of(:iban).with_message('is not looking good') }
end
```

### Options

```rdoc
:message_for_invalid
   String. A custom error message when the iban is invalid (default is: "is invalid")

:message_for_missing
   String. A custom error message when the iban is missing (default is: "is missing")

:optional
   Boolean. Flag to turn off valdiation for blank/nil case

:generate_message
  Boolean. Return the I18n key of the error message instead of the error message itself (default is false)

:on, :if, :unless, :allow_nil, :allow_blank, :strict
   Standard ActiveModel validation options.  These work in the ActiveModel/ActiveRecord/Rails syntax only.
   See http://api.rubyonrails.org/classes/ActiveModel/Validations/ClassMethods.html#method-i-validates for details.
```

# Testing

To execute the unit tests run <tt>rspec</tt>.

# Credits

Written by [Dimitar Kostov](https://github.com/mytrile) [mitko.kostov@gmail.com](mailto:mitko.kostov@gmail.com)

Many thanks to the [iban-tools gem](https://github.com/alphasights/iban-tools) for the real validation


# LICENSE

Copyright (c) 2017 Dimitar Kostov

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
