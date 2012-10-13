# Load plugins (only those I whitelist)
Pry.config.should_load_plugins = false
Pry.plugins["doc"].activate!

# Load 'awesome_print'
begin
  require 'awesome_print'
  Pry.config.print = proc { |output, value| Pry::Helpers::BaseHelpers.stagger_output("=> #{value.ai}", output) }
rescue LoadError => err
end

# Load 'hirb'
begin
  require 'hirb'

  Pry.config.print = proc do |output, value|
    Hirb::View.view_or_page_output(value) || Pry::DEFAULT_PRINT.call(output, value)
  end

  Hirb.enable
rescue LoadError => err
end

# Launch Pry with access to the entire Rails stack
rails = File.join(Dir.getwd, 'config', 'environment.rb')

if File.exist?(rails) && ENV['SKIP_RAILS'].nil?
  require rails

  if Rails.version[0..0] == "2"
    require 'console_app'
    require 'console_with_helpers'
  elsif Rails.version[0..0] == "3"
    require 'rails/console/app'
    require 'rails/console/helpers'
  else
    warn "[WARN] cannot load Rails console commands (Not on Rails2 or Rails3?)"
  end

  # Rails' pry prompt
  env = ENV['RAILS_ENV'] || Rails.env
  rails_root = File.basename(Dir.pwd)

  rails_env_prompt = case env
    when 'development'
      '[DEV]'
    when 'production'
      '[PROD]'
    else
      "[#{env.upcase}]"
    end

  prompt = '%s %s %s:%s'
  Pry.config.prompt = [ proc { |obj, nest_level, *| "#{prompt}> " % [rails_root, rails_env_prompt, obj, nest_level] },
                        proc { |obj, nest_level, *| "#{prompt}* " % [rails_root, rails_env_prompt, obj, nest_level] } ]

  # [] acts as find()
  ActiveRecord::Base.instance_eval { alias :[] :find } if defined?(ActiveRecord)

  # Add Rails console helpers (like `reload!`) to pry
  if defined?(Rails::ConsoleMethods)
    extend Rails::ConsoleMethods
  end

  # r! to reload Rails console
  def r!
    reload!
  end

  # sql for arbitrary SQL commands through the AR
  def sql(query)
    ActiveRecord::Base.connection.execute(query)
  end

  # set logging to screen
  if ENV.include?('RAILS_ENV')
    # Rails 2.x
    if !Object.const_defined?('RAILS_DEFAULT_LOGGER')
      require 'logger'
      Object.const_set('RAILS_DEFAULT_LOGGER', Logger.new(STDOUT))
    end
  else
    # Rails 3
    if Rails.logger and defined?(ActiveRecord)
      Rails.logger = Logger.new(STDOUT)
      ActiveRecord::Base.logger = Rails.logger
    end
  end
end

# alias 'q' for 'exit'
Pry.config.commands.alias_command "q", "exit-all"
