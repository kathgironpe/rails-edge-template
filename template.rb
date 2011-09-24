get 'https://raw.github.com/bridgeutopia/sleep/master/Gemfile', 'Gemfile'

remove_file     "public/index.html"
remove_file     "public/images/rails.png"

say <<-eos
  ============================================================================
  Installing dependencies. This will take a while. 
  Sleep... 
  zzz...
eos

run 'bundle install'

if yes?("Would you like to install Devise?")
  generate("devise:install")
  model_name = ask("What would you like the user model to be called? [user]")
  model_name = "user" if model_name.blank?
  generate("devise", model_name)
end