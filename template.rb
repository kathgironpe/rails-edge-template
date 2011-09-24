get 'https://raw.github.com/bridgeutopia/sleep/master/Gemfile', 'Gemfile'

remove_file     "public/index.html"
remove_file     "public/images/rails.png"


if yes?("Would you like to proceed and create a database config file?")
  get 'https://raw.github.com/bridgeutopia/sleep/master/config/database.yml', 'config/database.yml'

  database_name = ask("What's the name of the prefix name for the database?")
  database_name = "sleep" if database_name.blank?
  gsub_file 'config/database.yml', /sleep/, "#{database_name}"
  
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
  Best practice: validators and cache sweepers should be within in its own directory. 
eos

insert_into_file "config/application.rb", 'config.autoload_paths += %W(#{config.root}/app/sweepers) '"\n"' ', :after => "class Application < Rails::Application\n"
insert_into_file "config/application.rb", 'config.autoload_paths += %W(#{config.root}/app/jobs) '"\n"'', :after => "class Application < Rails::Application\n"
insert_into_file "config/application.rb", 'config.autoload_paths += %W(#{config.root}/app/model/validators) '"\n"'', :after => "class Application < Rails::Application\n"
insert_into_file "config/application.rb", 'config.autoload_paths += %W(#{config.root}/lib) '"\n"'', :after => "class Application < Rails::Application\n"

insert_into_file "config/application.rb", 'config.generators do |g| '"\n"' g.template_engine :haml '"\n"' g.test_framework :rspec, '"\n"' :fixture => false '"\n"' end '"\n"'', :after => "class Application < Rails::Application\n"
   	
   
if yes?("Would you like to install RSpec?")
  generate("rspec:install")
end


if yes?("Would you like to install Cucumber?")
  generate("cucumber:install")
end


if yes?("Would you like to install Devise?")
  generate("devise:install")
  model_name = ask("What would you like the user model to be called? [user]")
  model_name = "user" if model_name.blank?
  generate("devise", model_name)
end

