require 'comet'

describe Comet::API do
  let(:gem_info) do
    File.read(File.join(File.dirname(__FILE__), '../../data/rubygems_info.json'))
  end

  describe '.latest_gem_version' do
    it 'queries the rubygems.org API' do
      expect(RestClient).to receive(:get)
        .with(Comet::API::RUBYGEMS_URL)
        .and_return(gem_info)

      expect(Comet::API.latest_gem_version).to eq('0.0.7')
    end
  end

end
