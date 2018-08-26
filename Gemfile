source "https://rubygems.org"

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

# Specify your gem's dependencies in cacchern.gemspec
gemspec

group :development, :test do
  gem 'rspec'
  gem 'dotenv'
end

group :test do
  gem 'database_cleaner'
end