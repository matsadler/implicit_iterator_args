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
        original = instance_method(name)
        define_method(name) do |*args, &block|
          result = original.bind(self).call(*args) do |*args|
            ImplicitIteratorArgs.current = args
            block.call(*args)
          end
          ImplicitIteratorArgs.current = nil
          result
        end
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