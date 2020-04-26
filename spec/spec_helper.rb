# frozen_string_literal: true

# Replicates much of the testing framework from ArcLight Core; see:
# https://github.com/projectblacklight/arclight/blob/master/spec/spec_helper.rb

ENV['RAILS_ENV'] ||= 'test'
ENV['REPOSITORY_FILE'] ||= 'spec/fixtures/config/repositories.yml'
require File.expand_path('../config/environment', __dir__)
SPEC_ROOT = Pathname.new(__dir__)

require 'rspec/rails'

require 'selenium-webdriver'
require 'webdrivers'

Capybara.javascript_driver = :headless_chrome

Capybara.register_driver :headless_chrome do |app|
  Capybara::Selenium::Driver.load_selenium
  browser_options = ::Selenium::WebDriver::Chrome::Options.new.tap do |opts|
    opts.args << '--headless'
    opts.args << '--disable-gpu'
    opts.args << '--no-sandbox'
    opts.args << '--window-size=1280,1696'
  end
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: browser_options)
end

Capybara.default_max_wait_time = 15 # our ajax responses are sometimes slow

Capybara.enable_aria_label = true

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
