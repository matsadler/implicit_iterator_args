require 'thread'

module ImplicitIteratorArgs
  class << self
    def current
      Thread.current[:"ImplicitIteratorArgs::current"]
    end
    
    def current=(value)
      Thread.current[:"ImplicitIteratorArgs::current"] = value
    end
    
    def included(includer)
      def includer.enable_implicit_iterator_args(name)
        alias_method :"explicit_#{name}", name
        class_eval(%Q{def #{name}(*args, &block)
          result = explicit_#{name}(*args) do |*args|
            ImplicitIteratorArgs.current = args
            block.call(*args)
          end
          ImplicitIteratorArgs.current = nil
          result
        end})
      end
      includer.enable_implicit_iterator_args(:each)
      if includer.include?(Enumerable)
        Enumerable.instance_methods.each do |method|
          includer.enable_implicit_iterator_args(method)
        end
      end
    end
    
  end
end