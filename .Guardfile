# Global Guardfile (more info at https://github.com/guard/guard#readme)

# Pass ignore option to the `listen` gem

# Ignore public/ directory in the project (i.e. changes to files there should not trigger any actions)
ignore /public\//

# Ignore root of the project. This is a workaround for a bug with `listen` gem and 'polling'.
# Sometimes something will trigger a filechange at root of the project ('.') and listen/guard
# will then do a polling for all files in a project directory (including git, bundle, tmp and
# others). Adding root dir to ignore seems to fix it.
ignore /\A\.\Z/

if Gem::Specification.find_all_by_name('activesupport').any?
  # so that we can use String#singularize
  require 'active_support/inflector'
end

if Gem::Specification.find_all_by_name('guard-livereload').any?
  guard 'livereload' do
    watch(%r{.+\.html})
    watch(%r{.+\.css})
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
    # Restart application server
    watch('Gemfile.lock')                       { |_| `touch tmp/restart.txt` }
    watch(%r{^lib/.*})                          { |_| `touch tmp/restart.txt` }
    watch('config/environments/development.rb') { |_| `touch tmp/restart.txt` }
    watch(%r{^config/locales/.+\.yml$})         { |_| `touch tmp/restart.txt` }
    watch('config/application.yml')             { |_| `touch tmp/restart.txt` }
    watch('config/secrets.yml')                 { |_| `touch tmp/restart.txt` }
    watch('config/settings.yml')                { |_| `touch tmp/restart.txt` }
    watch('config/settings.local.yml')          { |_| `touch tmp/restart.txt` }
    watch(%r{^config/initializers/.+\.rb$})     { |_| `touch tmp/restart.txt` }
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
    watch(%r{^config/locales/.+\.yml$})
    watch('db/schema.rb')
    watch('Gemfile.lock')
    watch(%r{^lib/.+\.rb$})
    watch('spec/spec_helper.rb')
    watch(%r{^spec/support/.+\.rb$})
  end
end

if Gem::Specification.find_all_by_name('guard-rspec').any?
  zeus = File.exist?('.zeus.sock')
  spork = Gem::Specification.find_all_by_name('spork').any?
  spring = Gem::Specification.find_all_by_name('spring').any?

  cmd = ''
  cmd += 'zeus ' if zeus
  cmd += 'spring ' if spring
  cmd += 'rspec --color --fail-fast --profile 0 --format documentation '
  cmd += '--drb ' if spork

  guard 'rspec', failed_mode: :keep, cmd: cmd do
    # Spec files
    watch(%r{^spec/.+_spec\.rb$})

    # Factories
    watch(%r{^spec/factories/(.+)\.rb$}) do |m|
      [
        "spec/models/#{m[1].singularize}_spec.rb",
        "spec/controllers/#{m[1]}_controller_spec.rb",
        "spec/requests/#{m[1]}_spec.rb",
        "spec/requests/#{m[1]}_requests_spec.rb",
        "spec/requests/#{m[1].singularize}_spec.rb",
        "spec/requests/#{m[1].singularize}_requests_spec.rb",
      ]
    end

    # Rails specific
    watch(%r{^app/(.+)\.rb$})                          { |m| "spec/#{m[1]}_spec.rb" }
    watch(%r{^lib/(.+)\.rb$})                          { |m| "spec/lib/#{m[1]}_spec.rb" }
    watch(%r{^app/controllers/(.+)_(controller)\.rb$}) do |m|
      [
        "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb",
        "spec/acceptance/#{m[1]}_spec.rb",
        "spec/requests/#{m[1]}_spec.rb",
        "spec/requests/#{m[1]}_requests_spec.rb",
        "spec/requests/#{m[1].singularize}_spec.rb",
        "spec/requests/#{m[1].singularize}_requests_spec.rb",
      ]
    end
    watch('app/controllers/application_controller.rb') { "spec/controllers" }
    watch(%r{^app/views/(.+)$})                        { |m| "spec/views/#{m[1]}_spec.rb" }

    # Capybara request specs
    watch(%r{^app/views/(.+)/.*\.(erb|haml|slim)$})    { |m| "spec/requests/#{m[1]}_spec.rb" }

    # Controller specs for views
    watch(%r{^app/views/(.+)/.*\.(erb|haml|slim)$})    { |m| "spec/controllers/#{m[1]}_spec.rb" }

    # Turnip features and steps
    watch(%r{^spec/acceptance/(.+)\.feature$})
    watch(%r{^spec/acceptance/steps/(.+)_steps\.rb$})  { |m| Dir[File.join("**/#{m[1]}.feature")][0] || 'spec/acceptance' }

    # Runs all specs when something in /lib is modified (for Ruby gems development)
    if Dir.glob('*.gemspec').any?
      watch(%r{^lib/.+\.rb$}) { "spec" }
    end

    # Standalone projects
    watch(%r{^(.+)\.rb$}) { |m| "spec/#{m[1]}_spec.rb" }

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

if Gem::Specification.find_all_by_name('guard-minitest').any?
  guard 'minitest', all_on_start: false, bundler: false do
    watch(%r{(.+)\.rb$})               { |m| "test/#{m[1]}_test.rb" }
    watch(%r{^lib/(.+)\.rb$})          { |m| "test/#{m[1]}_test.rb" }
    watch(%r{^test/.+_test\.rb$})
    watch(%r{^test/test_helper\.rb$})  { 'test' }
  end
end

if Gem::Specification.find_all_by_name('guard-delayed').any?
  guard 'delayed', :environment => 'development' do
    watch(%r{^app/(.+)\.rb$})
  end
end
