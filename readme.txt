Allows you to use _ to retrieve the arguments to a block, eg:

  require 'implicit_iterator_args'
  
  class Array
    include ImplicitIteratorArgs
  end
  
  [1, 2, 3].each {print _}      # prints '123'
  [1, 2, 3].inject(4) {_ + _}   # => 10

This is only really a proof of concept, while the above works, anything more involved is likely to have problems.
  
  array1 = [1, 2, 3]
  array2 = ["a", "b", "c"]
  
  array1.each do
    print _
    array2.each do
      print _
    end
  end
  
  # prints '1abc2abc3abc'
  
  array1.each do
    array2.each do
      print _
    end
    print _
  end
  
  # prints 'abcnilabcnilabcnil'