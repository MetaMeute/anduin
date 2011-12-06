source 'http://rubygems.org'

gem 'rails', '~> 3.1'

gem 'sqlite3'

# Asset template engines
gem 'json'
gem 'sass-rails', "~> 3.1.0"
gem 'haml'
gem 'coffee-script'
gem 'therubyracer'
gem 'uglifier'

gem 'jquery-rails'
gem 'simple-navigation'

gem 'devise'
gem 'devise_ldap_authenticatable'
gem 'net-ldap'

gem 'gollum'
gem 'rdiscount'
gem 'rdoc', "< 3.10"

#this needs to be in here for file assets to work. somehow it’s not enough to have it as dependency of fassets_core :/
gem 'paperclip'
gem 'fancybox-rails'

# for now the git version of fassets core should be used, since it’s under heavy development
gem 'fassets_core', :git => "git://github.com/fassets/fassets_core.git"

group :development, :test do
  gem 'rspec-rails'
  gem 'cucumber-rails'
  gem 'database_cleaner'
  gem 'spork'
end
