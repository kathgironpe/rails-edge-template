remove_file     "Gemfile"
remove_file     "public/index.html"
remove_file     "public/images/rails.png"

get 'https://raw.github.com/bridgeutopia/sleep/master/Gemfile', 'Gemfile'


if yes?("Would you like to proceed and create a database config file?")
  
  if yes?("Would you like to use MySQL instead of PostgreSQL?")
    get 'https://raw.github.com/bridgeutopia/sleep/master/config/database.mysql.yml', 'config/database.yml'
    gsub_file 'Gemfile', /pg/, "mysql2"
  else
    get 'https://raw.github.com/bridgeutopia/sleep/master/config/database.postgresql.yml', 'config/database.yml'
  end
  

  database_name = ask("What's the name of the prefix name for the database?")
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

run 'bundle install'

say <<-eos
  ============================================================================
  Updating application.rb
  Creating app/sweepers directory.
  Creating app/jobs directory.
  Creating app/model/validators directory.
  Best practice: validators and cache sweepers should be within in its own directory. 
eos

inside('app') do
  run('mkdir sweepers')
  run('mkdir jobs')
  run('mkdir -p model/validators')
end

insert_into_file "config/application.rb", 'config.autoload_paths += %W(#{config.root}/app/sweepers) '"\n"' ', :after => "class Application < Rails::Application\n"
insert_into_file "config/application.rb", 'config.autoload_paths += Dir["#{config.root}/lib/**/"] '"\n"' ', :after => "class Application < Rails::Application\n"
insert_into_file "config/application.rb", 'config.autoload_paths += %W(#{config.root}/app/jobs) '"\n"'', :after => "class Application < Rails::Application\n"
insert_into_file "config/application.rb", 'config.autoload_paths += %W(#{config.root}/app/model/validators) '"\n"'', :after => "class Application < Rails::Application\n"
insert_into_file "config/application.rb", 'config.autoload_paths += %W(#{config.root}/lib) '"\n"'', :after => "class Application < Rails::Application\n"
insert_into_file "config/application.rb", 'config.generators do |g| '"\n"' g.template_engine :haml '"\n"' g.fixture_replacement :factory_girl, :dir => "spec/factories"  '"\n"'  g.test_framework :rspec, '"\n"' :fixture => false '"\n"' end '"\n"'', :after => "class Application < Rails::Application\n"
  
get 'https://raw.github.com/bridgeutopia/sleep/master/.gitignore', '.gitignore'

if yes?("Would you like to install RSpec, Email Spec, Spork and Cucumber?")
  generate("rspec:install")
  generate("cucumber:install")
  insert_into_file "features/support/env.rb", 'require "email_spec/cucumber"', :after => "require 'cucumber/rails'\n"
  generate("email_spec:steps")
  get 'https://raw.github.com/bridgeutopia/sleep/master/spec/spec_helper.rb', 'spec/spec_helper.rb'
  get 'https://github.com/bridgeutopia/sleep/blob/master/Guardfile' , 'Guardfile'
  inside('spec') do
    run('mkdir factories')
  end
end


if yes?("Would you like to install Devise?")
  generate("devise:install")
  model_name = ask("What would you like the user model to be called? [user]")
  model_name = "user" if model_name.blank?
  generate("devise", model_name)
end

if yes?("Would you like to use Twitter Bootstrap?")
  remove_file  "app/views/layouts/application.html.erb"
  get 'https://raw.github.com/bridgeutopia/sleep/master/app/views/layouts/application.html.haml', 'app/views/layouts/application.html.haml'
  get 'https://raw.github.com/bridgeutopia/sleep/master/app/assets/stylesheets/application.scss', 'app/assets/stylesheets/application.scss'
end
