require 'rest-client'
require 'comet'

Dir[File.join(File.dirname(__FILE__), 'support/**/*.rb')].each { |f| require f }

RSpec.configure do |config|
  config.include SampleData
  config.include OutputCatcher

  config.before(:each) do
    RestClient.stub(:get)
    RestClient.stub(:post)
  end
end
