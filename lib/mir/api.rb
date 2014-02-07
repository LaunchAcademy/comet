require 'net/http'
require 'json'

module Mir
  class API
    def self.get_challenges(config)
      request_with_token("http://localhost:3000/challenges.json", config['token'])
    end

    def self.get_challenge(config, id)
      request_with_token("http://localhost:3000/challenges/#{id}.json", config['token'])
    end

    private

    def self.request_with_token(url, token)
      uri = URI(url)

      request = Net::HTTP::Get.new(uri)
      request['Authorization'] = "Token #{token}"
      response = Net::HTTP.start(uri.hostname, uri.port) do |http|
        http.request(request)
      end

      JSON.parse(response.body, symbolize_names: true)
    end
  end
end
