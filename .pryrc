# alias 'q' for 'exit'
Pry.config.commands.alias_command "q", "exit-all"

# Load 'awesome_print'
begin
  require 'awesome_print'
  require 'awesome_print/ext/active_record'
  require 'awesome_print/ext/active_support'
  require 'awesome_print/ext/mongoid'
  require 'awesome_print/ext/nokogiri'
  require 'awesome_print/ext/ostruct'

  AwesomePrint.pry!
rescue LoadError => err
end

# Load 'hirb'
begin
  require 'hirb'

  Hirb.enable

  pry_print = Pry.config.print

  Pry.config.print = proc do |*args|
    Hirb::View.view_or_page_output(args[1]) || pry_print.call(*args)
  end
rescue LoadError => err
end

# Launch Pry with access to the entire Rails stack
rails = File.join(Dir.getwd, 'config', 'environment.rb')

# Disable pry's shell integration (handle pasted Ruby code starting with a dot)
Pry.commands.delete /\.(.*)/

if File.exist?(rails) && ENV['SKIP_RAILS'].nil?
  require rails

  if Rails.version[0..0] == "2"
    require 'console_app'
    require 'console_with_helpers'
  elsif Rails.version[0..0].in?(['3', '4', '5'])
    require 'rails/console/app'
    require 'rails/console/helpers'
  else
    warn "[WARN] cannot load Rails console commands (Not using Rails v2-5?)"
  end

  # Rails' pry prompt
  env = ENV['RAILS_ENV'] || Rails.env
  rails_root = File.basename(Dir.pwd)

  rails_env_prompt =
    case env
    when 'development'
      '[DEV]'
    when 'production'
      '[PROD]'
    else
      "[#{env.upcase}]"
    end

  prompt = '%s %s %s:%s'

  Pry.config.prompt = Pry::Prompt.new \
    'Prompt',
    'Custom prompt',
    [
      proc { |obj, _nest_level, pry_instance| "#{prompt}> " % [rails_root, rails_env_prompt, obj, pry_instance.input_ring.count] },
      proc { |obj, _nest_level, pry_instance| "#{prompt}* " % [rails_root, rails_env_prompt, obj, pry_instance.input_ring.count] }
    ]

  # [] acts as find()
  ActiveRecord::Base.instance_eval { alias :[] :find } if defined?(ActiveRecord)

  # Add Rails console helpers (like `reload!`) to pry
  if defined?(Rails::ConsoleMethods)
    extend Rails::ConsoleMethods
  end

  # r! to reload Rails console
  if defined?(Rails) && Rails.version.to_f >= 3.0
    def r!
      reload!
    end
  end

  # execute arbitrary SQL query through ActiveRecord
  def execute query
    ActiveRecord::Base.connection.execute query
  end

  # set logging to screen in Rails
  if defined? Rails
    # Rails 2.x
    if ENV.include?('RAILS_ENV') && !Object.const_defined?('RAILS_DEFAULT_LOGGER')
      require 'logger'
      Object.const_set('RAILS_DEFAULT_LOGGER', Logger.new(STDOUT))
    end

    # Rails 3+
    if Rails.logger && defined? ActiveRecord
      Rails.logger = Logger.new(STDOUT)
      ActiveRecord::Base.logger = Rails.logger
    end
  end

  # .details method for pretty printing ActiveRecord's objects attributes
  class Object
    def details
      if self.respond_to?(:attributes) and self.attributes.any?
        max = self.attributes.keys.sort_by { |k| k.size }.pop.size + 5

        puts

        self.attributes.keys.sort.each do |k|
          puts sprintf("%-#{max}.#{max}s%s", k, self.try(k))
        end

        puts
      end
    end
    alias :detailed :details
  end

  # returns a collection of the methods that Rails added to the given class
  # http://lucapette.com/irb/rails-core-ext-and-irb/
  class Class
    def core_ext
      self
        .instance_methods
        .map { |m| [m, self.instance_method(m).source_location] }
        .select { |m| m[1] && m[1][0] =~/activesupport/ }
        .map { |m| m[0] }
        .sort
    end
  end

  # local methods helper
  # http://rakeroutes.com/blog/customize-your-irb/
  class Object
    def local_methods
      case self.class
      when Class
        self.public_methods.sort - Object.public_methods
      when Module
        self.public_methods.sort - Module.public_methods
      else
        self.public_methods.sort - Object.new.public_methods
      end
    end
  end
end
