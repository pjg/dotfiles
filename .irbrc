# pretty print from the Ruby Standard Library
require 'pp'

# require console enhancement gems (you need to list them in the Gemfile in the :development & :test groups)
%w(rubygems ap interactive_editor hirb wirble).each do |gem|
  begin
    require gem
  rescue LoadError
  end
end

# Initialize Wirble
if defined?(Wirble)
  Wirble.init
  Wirble.colorize
end

# Initialize Hirb
Hirb.enable if defined?(Hirb)

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

# q for exit
alias q exit

# load .railsrc when in 'script/console'
load File.dirname(__FILE__) + '/.railsrc' if ($0 == 'irb' && ENV['RAILS_ENV']) || ($0 == 'script/rails' && Rails.env)

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
