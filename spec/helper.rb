$:.unshift File.expand_path('..', __FILE__)
$:.unshift File.expand_path('../../lib', __FILE__)

require 'yandex-webmaster'
require 'rspec'
require 'webmock/rspec'
require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/cassettes'
  config.hook_into(:webmock)
  config.ignore_localhost = true
  config.default_cassette_options = { :record => :once }
  config.configure_rspec_metadata!
end

RSpec.configure do |config|
  config.include WebMock::API
  config.order = :rand
  config.color_enabled = true
  config.treat_symbols_as_metadata_keys_with_true_values = true

  config.before(:each) do
    WebMock.reset!
  end
  config.after(:each) do
    WebMock.reset!
  end
end

APPLICATION_ID = '663576cbd55948a4ae45424fb508ef97'
APPLICATION_PASSWORD = 'fc2f76dc877e41a4a6cbe78d73faff85'

token_file = File.expand_path('../.access_token', __FILE__)
if File.exists?(token_file)
  ACCESS_TOKEN = File.read(token_file).strip
else  
  ACCESS_TOKEN = 'FAKETOKEN'
  puts "You are using a fake access token. You can only use API responds recorded by VCR"
end