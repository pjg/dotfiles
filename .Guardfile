# Global Guardfile (more info at https://github.com/guard/guard#readme)

if Gem::Specification.find_all_by_name('activesupport').any?
  # so that we can use String#singularize
  require 'active_support/inflector'
end

if Gem::Specification.find_all_by_name('guard-livereload').any?
  guard 'livereload' do
    watch(%r{app/views/.+\.(erb|haml|slim)})
    watch(%r{app/helpers/.+\.rb})
    watch(%r{public/.+\.(css|js|html)})
    watch(%r{config/locales/.+\.yml})
    # Rails Assets Pipeline
    watch(%r{(app|vendor)(/assets/\w+/(.+\.(s[ac]ss|css|coffee|js|html))).*}) { |m| "/assets/#{m[3]}" }
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
    watch('Gemfile.lock')                       { |m| `touch tmp/restart.txt` }
    watch(%r{^lib/.*})                          { |m| `touch tmp/restart.txt` }
    watch('config/environments/development.rb') { |m| `touch tmp/restart.txt` }
    watch(%r{^config/initializers/.+\.rb$})     { |m| `touch tmp/restart.txt` }
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
  guard 'spork', :wait => 180, :cucumber => false, :rspec_env => { 'RAILS_ENV' => 'test' }, :test_unit_env => { 'RAILS_ENV' => 'test' } do
    watch('config/application.rb')
    watch('config/environment.rb')
    watch('config/environments/test.rb')
    watch('config/routes.rb')
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
  turnip = Gem::Specification.find_all_by_name('turnip').any?
  parallel = Gem::Specification.find_all_by_name('parallel_tests').any?
  zeus = File.exists?('.zeus.sock')
  drb = '--drb' if Gem::Specification.find_all_by_name('spork').any?

  guard 'rspec', :bundler => false, :turnip => turnip, :zeus => zeus, :parallel => parallel, :parallel_cli => "-n 2", :all_on_start => false, :all_after_pass => false, :keep_failed => false, :focus_on_failed => true, :cli => "--color --fail-fast #{ drb }" do
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
    watch(%r{^app/views/(.+)$})                        { |m| "spec/views/#{m[1]}_spec.rb" }

    # Capybara request specs
    watch(%r{^app/views/(.+)/.*\.(erb|haml|slim)$})    { |m| "spec/requests/#{m[1]}_spec.rb" }

    # Controller specs for views
    watch(%r{^app/views/(.+)/.*\.(erb|haml|slim)$})    { |m| "spec/controllers/#{m[1]}_spec.rb" }

    # Turnip features and steps
    watch(%r{^spec/acceptance/(.+)\.feature$})
    watch(%r{^spec/acceptance/steps/(.+)_steps\.rb$})  { |m| Dir[File.join("**/#{m[1]}.feature")][0] || 'spec/acceptance' }

    # Runs all specs when something in /lib is modified. Might be overkill, but helps tremendously during Gem development
    watch(%r{^lib/.+\.rb$}) { "spec" }

    # Ignore Zeus
    ignore(/\.zeus\.sock/)
  end
end

if Gem::Specification.find_all_by_name('guard-test').any?
  guard 'test', :all_on_start => false, :all_after_pass => false, :bundler => true, :keep_failed => false, :cli => '--verbose=normal', :drb => true do
    watch(%r{^lib/(.+)\.rb$})     { |m| "test/#{m[1]}_test.rb" }
    watch(%r{^test/.+_test\.rb$})
    watch('test/test_helper.rb')  { "test" }

    # Rails
    watch(%r{^app/models/(.+)\.rb$})                   { |m| "test/unit/#{m[1]}_test.rb" }
    watch(%r{^app/controllers/(.+)\.rb$})              { |m| "test/functional/#{m[1]}_test.rb" }
    watch(%r{^app/views/.+\.rb$})                      { "test/integration" }
    watch('app/controllers/application_controller.rb') { ["test/functional", "test/integration"] }
  end
end

if Gem::Specification.find_all_by_name('guard-delayed').any?
  guard 'delayed', :environment => 'development' do
    watch(%r{^app/(.+)\.rb$})
  end
end
