# Capybara::Jasmine

Run Jasmine Specs via Capybara. That way, you can run it under any of capybara's javascript drivers. Headless yay!

## Installation

Add this line to your application's Gemfile:

    gem 'capybara-jasmine'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install capybara-jasmine

## Usage

Capybara::Jasmine follows Rake TestTask's style of definition (since it is a test task). Add this to your `Rakefile` (or in Rails under `lib/tasks/capybara_jasmine.rake` for example):

```ruby
# Load the library
require 'capybara-jasmine'

# In this case, I want to use webkit, so load it
require 'capybara-webkit'

# Define my task. Arguments are the same as any rake task (dependencies, etc)
# In this case, I'll name it "capyspec" and it will depend on my "coffee"
# task that compiles my coffeescript.
Capybara::Jasmine::TestTask.new "capyspec" => "coffee" do |t|

  # Inside the block runs just before running the test, so you can
  # do any capybara setup here. I'm going to set the JS driver to
  # webkit instead of the default selenium.
  Capybara.javascript_driver = :webkit

  # Like Rake::TestTask, tell it what your lib files are.
  # Here, I'm mixing some files that must come first (order dependent)
  # with some wildcard searches, and then uniqing so they don't show up
  # multiple times and overwrite each other
  t.lib_files = ([
    "vendor/jquery-1.8.2.js",
    "vendor/underscore.js",
    "vendor/backbone.js",
    "public/mb.js"
  ] + FileList["public/**/*.js"]).uniq
  
  # Lastly, our spec files. This can just be a wildcard in my case
  t.spec_files = FileList["spec/**/*Spec.js"]
end
```

Now, I just run `rake capyspec` and I get something like this:

```
Failed: True should not be truthy
Error: Expected true not to be truthy.

Passed: True should be truthy
```
