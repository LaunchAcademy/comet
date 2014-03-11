require 'rest-client'

Dir[File.join(File.dirname(__FILE__), 'support/**/*.rb')].each { |f| require f }

RSpec.configure do |config|
  config.include OutputCatcher
  config.include SampleData

  config.before(:each) do
    RestClient.stub(:get)
    RestClient.stub(:post)

    Comet::API.stub(:get_challenges).and_return(challenges_index_sample)
    Comet::API.stub(:latest_gem_version).and_return('0.0.0')
    Comet::API.stub(:get_challenge)
    Comet::API.stub(:download_archive)
  end
end
