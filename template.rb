remove_file     "Gemfile"
remove_file     "public/index.html"
remove_file     "public/images/rails.png"

get 'https://raw.github.com/katgironpe/sleep/master/Gemfile', 'Gemfile'

if yes?('Would you like to proceed and create a database config file?')

  if yes?('Would you like to use MySQL instead of PostgreSQL?')
    get 'https://raw.github.com/katgironpe/sleep/master/config/database.mysql.yml', 'config/database.yml'
    gsub_file 'Gemfile', /pg/, "mysql2"
  else
    get 'https://raw.github.com/katgironpe/sleep/master/config/database.postgresql.yml', 'config/database.yml'
  end

  database_name = ask("What's the prefix name for the database?")
  database_name = "sleep" if database_name.blank?
  gsub_file 'config/database.yml', /sleep/, "#{database_name}"

  database_username = ask("What's your username for your database?")
  database_username = "" if database_username.blank?
  gsub_file 'config/database.yml', /katz/, "#{database_username}"

  say <<-eos
  ============================================================================
    Creating config file...
  eos

end

say <<-eos
  ============================================================================
  Installing dependencies. This will take a while.
  Sleep...
  zzz...
eos

run 'bundle install --no-deployment'

say <<-eos
  ============================================================================
  Updating application.rb
  Creating app/sweepers directory.
  Creating app/workers directory.
  Creating app/models/validators directory.
  Best practice: validators and cache sweepers should be within in its own directory.
eos

inside('app') do
  run('mkdir sweepers')
  run('mkdir workers')
  run('mkdir -p models/validators')
end

rails_config = <<-eos
    # Rails generators
    config.generators do |g|
      g.template_engine :haml
      g.fixture_replacement :factory_girl, dir: "spec/factories"
      g.test_framework :rspec, fixture: false
    end
eos

insert_into_file 'config/application.rb', rails_config, after: "class Application < Rails::Application\n"

get 'https://raw.githubusercontent.com/github/gitignore/master/Rails.gitignore', '.gitignore'

say <<-eos
  ============================================================================
  There's a still lot to do here but it's best to install
  all of those stuff without a generator.
  Consider reading about devise, cancan and guard-rspec.
eos
