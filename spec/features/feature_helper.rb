require 'rails_helper'


RSpec.configure do |config|
  Capybara.javascript_driver = :webkit
  
  config.use_transactional_fixtures = false

  config.include AcceptanceHelper, type: :feature

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, type: :feature, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
    FileUtils.rm_rf(CarrierWave.root)
  end
end