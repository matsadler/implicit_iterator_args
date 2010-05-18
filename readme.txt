Allows you to use _ to retrieve the arguments to a block, eg:

  require 'implicit_iterator_args'
  
  class Array
    include ImplicitIteratorArgs
  end
  
  [1, 2, 3].each {print _}      # prints '123'
  [1, 2, 3].inject(4) {_ + _}   # => 10

However this is quite a hack, and isn't recommended for actual use.

Known bugs:
Trying to access the argument with _ from another thread fails, eg:

  [1, 2, 3].each {Thread.new {print _}.join}   # prints 'nilnilnil'
  