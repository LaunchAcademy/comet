require 'rest-client'

Dir[File.join(File.dirname(__FILE__), 'support/**/*.rb')].each { |f| require f }

RSpec.configure do |config|
  config.include OutputCatcher

  config.before(:each) do
    RestClient.stub(:get)
    RestClient.stub(:post)
    Comet::API.stub(:get_challenges)
    Comet::API.stub(:get_challenge)
    Comet::API.stub(:download_archive)
  end
end
