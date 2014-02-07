require 'net/http'
require 'json'

module Mir
  class API
    def self.get_challenges(config)
      url = URI('http://localhost:3000/challenges.json')

      request = Net::HTTP::Get.new(url)
      request['Authorization'] = "Token #{config['token']}"
      response = Net::HTTP.start(url.hostname, url.port) do |http|
        http.request(request)
      end

      JSON.parse(response.body, symbolize_names: true)
    end
  end
end
