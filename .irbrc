require 'rubygems'
require 'wirble'
require 'pp'
require 'ap'
require 'hirb'
Wirble.init
Wirble.colorize
Hirb.enable

# .local_methods method for all classes
class Object
  def local_methods(obj = self)
    (obj.methods - obj.class.superclass.instance_methods).sort
  end
end

# Documentation
#
# ri 'Array#pop'
# Array.ri
# Array.ri :pop
# arr.ri :pop
class Object
  def ri(method = nil)
    unless method && method =~ /^[A-Z]/ # if class isn't specified
      klass = self.kind_of?(Class) ? name : self.class.name
      method = [klass, method].compact.join('#')
    end
    puts `ri '#{method}'`
  end
end

# Log to STDOUT if in Rails (script/console)
if ENV.include?('RAILS_ENV') && !Object.const_defined?('RAILS_DEFAULT_LOGGER')
  require 'logger'
  RAILS_DEFAULT_LOGGER = Logger.new(STDOUT)
end

# q for exit
alias q exit

# load .railsrc when in 'script/console'
load File.dirname(__FILE__) + '/.railsrc' if $0 == 'irb' && ENV['RAILS_ENV']

# keep output manageable
class Array
  alias :__orig_inspect :inspect
  def inspect
    (length > 100) ? "[ ... #{length} elements ... ]" : __orig_inspect
  end
end

class Hash
  alias :__orig_inspect :inspect
  def inspect
    (length > 100) ? "{ ... #{length} keys ... }" : __orig_inspect
  end
end
