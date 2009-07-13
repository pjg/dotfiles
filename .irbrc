require 'rubygems'
require 'wirble'
require 'pp'
Wirble.init
Wirble.colorize

# .local_methods method for all classes
class Object
  def local_methods
    (methods - Object.instance_methods).sort
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
