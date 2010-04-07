module Kernel
  private
  def _
    ImplicitIteratorArgs.current.pop if ImplicitIteratorArgs.current
  end
end

path = "#{File.dirname(__FILE__)}/implicit_iterator_args/implementations"
begin
  eval("Proc.new {|&block|}")
  require "#{path}/block"
rescue SyntaxError
  require "#{path}/eval"
end