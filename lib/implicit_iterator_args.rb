require 'thread'

module Kernel
  private
  def _
    caller = Kernel.caller
    first = caller.find {|l| l =~ /implicit_iterator_args\/implementations/}
    caller.slice!(0, caller.index(first) + 4)
    
    caller_id = caller.hash
    ImplicitIteratorArgs[caller_id].pop if ImplicitIteratorArgs[caller_id]
  end
end

module ImplicitIteratorArgs
  class << self
    def store
      Thread.current[:implicit_iterator_args_store] ||= {}
    end
    
    def [](key)
      store[key]
    end
    
    def []=(key, value)
      store[key] = value
    end
    
    def delete(key)
      store.delete(key)
    end
  end
end

path = "#{File.dirname(__FILE__)}/implicit_iterator_args/implementations"
begin
  eval("Proc.new {|&block|}")
  require "#{path}/block"
rescue SyntaxError
  require "#{path}/eval"
end