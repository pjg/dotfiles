# Global Guardfile (more info at https://github.com/guard/guard#readme)

# so that we can use String#singularize
require 'active_support/inflector'

if Gem::Specification.find_all_by_name('guard-sass').any?
  guard 'sass',
    :input => 'app/assets/stylesheets',
    :output => 'public/stylesheets',
    :style => :expanded,
    :debug_info => true,
    :load_paths =>
      Dir.glob(File.join(Gem.dir, "gems", "compass*", "frameworks/blueprint/stylesheets")) +
      Dir.glob(File.join(Gem.dir, "gems", "compass*", "frameworks/compass/stylesheets")) +
      Dir.glob(File.join(Gem.dir, "gems", "bootstrap-sass*", "vendor/assets/stylesheets")) +
      Dir.glob(File.join(Gem.dir, "bundler", "gems", "exvo-assets*", "lib/assets/stylesheets"))
end

if Gem::Specification.find_all_by_name('guard-livereload').any?
  guard 'livereload' do
    # omit files starting with a dot (to prevent double reloads)
    watch(%r{^app/([a-zA-Z0-9_-]+/)+[^\.]+\.(erb|haml|slim)$})
    watch(%r{^app/helpers/([a-zA-Z0-9_-]+/)*[^\.]+\.rb})
    watch(%r{^public/([a-zA-Z0-9_-]+/)*[^\.]+\.(css|js|html)})
    watch(%r{^config/locales/([a-zA-Z0-9_-]+/)*[^\.]+\.yml})
    # Rails Assets Pipeline
    watch(%r{(app|vendor)(/assets/\w+/(.+\.(css|js|html))).*}) { |m| "/assets/#{m[3]}" }
  end
end

if Gem::Specification.find_all_by_name('guard-bundler').any?
  guard 'bundler' do
    watch('Gemfile')
  end
end

if Gem::Specification.find_all_by_name('guard-shell').any?
  guard 'shell' do
    # Restart passenger
    watch('Gemfile.lock')       { |m| `touch tmp/restart.txt` }
    watch(%r{^(config|lib)/.*}) { |m| `touch tmp/restart.txt` }
  end
end

if Gem::Specification.find_all_by_name('guard-delayed').any?
  guard 'delayed', :environment => 'development' do
    watch(%r{^app/(.+)\.rb})
  end
end

if Gem::Specification.find_all_by_name('guard-jasmine-headless-webkit').any?
  # Run JS and CoffeeScript files in a typical Rails 3.1 fashion, placing Underscore templates in app/views/*.jst
  # Your spec files end with _spec.{js,coffee}.
  spec_location = "spec/javascripts/%s_spec"

  guard 'jasmine-headless-webkit', :all_on_start => false do
    watch(%r{^app/views/.*\.jst$})
    watch(%r{^public/javascripts/(.*)\.js$}) { |m| newest_js_file(spec_location % m[1]) }
    watch(%r{^app/assets/javascripts/(.*)\.(js|coffee)$}) { |m| newest_js_file(spec_location % m[1]) }
    watch(%r{^spec/javascripts/(.*)_spec\..*}) { |m| newest_js_file(spec_location % m[1]) }
  end
end

if Gem::Specification.find_all_by_name('guard-spin').any?
  guard 'spin' do
    # RSpec
    # uses the .rspec file
    # --colour --fail-fast --format documentation --tag ~slow
    watch(%r{^spec/.+_spec\.rb$})
    watch(%r{^app/(.+)\.rb$})                          { |m| "spec/#{m[1]}_spec.rb" }
    watch(%r{^app/(.+)\.haml$})                        { |m| "spec/#{m[1]}.haml_spec.rb" }
    watch(%r{^lib/(.+)\.rb$})                          { |m| "spec/lib/#{m[1]}_spec.rb" }
    watch(%r{^app/controllers/(.+)_(controller)\.rb$}) { |m| ["spec/routing/#{m[1]}_routing_spec.rb", "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb", "spec/requests/#{m[1]}_spec.rb"] }

    # TestUnit
    watch(%r|^test/(.*)_test\.rb$|)
    watch(%r|^lib/(.*)([^/]+)\.rb$|)      { |m| "test/#{m[1]}test_#{m[2]}.rb" }
    watch(%r|^test/test_helper\.rb$|)     { "test" }
    watch(%r|^app/controllers/(.*)\.rb$|) { |m| "test/functional/#{m[1]}_test.rb" }
    watch(%r|^app/models/(.*)\.rb$|)      { |m| "test/unit/#{m[1]}_test.rb" }
  end
end

if Gem::Specification.find_all_by_name('guard-spork').any?
  guard 'spork', :wait => 180, :cucumber => false, :cucumber_env => { 'RAILS_ENV' => 'test' }, :rspec_env => { 'RAILS_ENV' => 'test' } do
    watch('config/application.rb')
    watch('config/environment.rb')
    watch('config/routes.rb')
    watch(%r{^config/environments/.+\.rb$})
    watch(%r{^config/initializers/.+\.rb$})
    watch('config/locales/en.yml')
    watch('Gemfile')
    watch('Gemfile.lock')
    watch('spec/spec_helper.rb') { :rspec }
    watch('test/test_helper.rb') { :test_unit }
    watch(%r{^lib/.+\.rb$})
    watch(%r{^spec/support/.+\.rb$})
  end
end

if Gem::Specification.find_all_by_name('guard-rspec').any?
  guard 'rspec', :all_on_start => false, :all_after_pass => false, :keep_failed => false, :cli => '--color --fail-fast --drb --backtrace' do
    # Factories
    watch('spec/factories.rb')                         { "spec" }
    watch(%r{^spec/factories/(.+)\.rb$})               { |m| ["spec/models/#{m[1].singularize}_spec.rb", "spec/controllers/#{m[1]}_controller_spec.rb", "spec/requests/#{m[1]}_spec.rb"] }

    # Global
    watch(%r{^spec/.+_spec\.rb$})
    watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
    watch('spec/spec_helper.rb')  { "spec" }

    # Rails specific
    watch(%r{^app/(.+)\.rb$})                          { |m| "spec/#{m[1]}_spec.rb" }
    watch(%r{^lib/(.+)\.rb$})                          { |m| "spec/lib/#{m[1]}_spec.rb" }
    watch(%r{^app/controllers/(.+)_(controller)\.rb$}) { |m| ["spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb", "spec/acceptance/#{m[1]}_spec.rb"] }
    watch(%r{^spec/support/(.+)\.rb$})                 { "spec" }
    watch('app/controllers/application_controller.rb') { "spec/controllers" }

    # Capybara request specs
    watch(%r{^app/views/(.+)/.*\.(erb|haml)$})         { |m| "spec/requests/#{m[1]}_spec.rb" }

    # Controller specs for views
    watch(%r{^app/views/(.+)/.*\.(erb|haml)$})         { |m| "spec/controllers/#{m[1]}_spec.rb" }

    # Runs all specs when something in /lib is modified. Might be overkill, but helps tremendously during Gem development
    watch(%r{^lib/.+\.rb$}) { "spec" }
  end
end

if Gem::Specification.find_all_by_name('guard-test').any?
  guard 'test', :all_on_start => false, :all_after_pass => false, :bundler => true, :keep_failed => false, :cli => '--verbose=normal' do
    watch(%r{^lib/(.+)\.rb$})     { |m| "test/#{m[1]}_test.rb" }
    watch(%r{^test/.+_test\.rb$})
    watch('test/test_helper.rb')  { "test" }

    # Rails example
    watch(%r{^app/models/(.+)\.rb$})                   { |m| "test/unit/#{m[1]}_test.rb" }
    watch(%r{^app/controllers/(.+)\.rb$})              { |m| "test/functional/#{m[1]}_test.rb" }
    watch(%r{^app/views/.+\.rb$})                      { "test/integration" }
    watch('app/controllers/application_controller.rb') { ["test/functional", "test/integration"] }
  end
end
