module ImplicitIteratorArgs
  class << self
    
    def included(includer)
      def includer.enable_implicit_iterator_args(name)
        alias_method :"explicit_#{name}", name
        class_eval(%Q{def #{name}(*args, &block)
          caller_id = Kernel.caller.hash
          result = explicit_#{name}(*args) do |*args|
            ImplicitIteratorArgs[caller_id] = args
            block.call(*args)
          end
          ImplicitIteratorArgs.delete(caller_id)
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