require 'net/http'
require 'json'

module Mir
  class API
    def self.get_challenges(config)
      response = request_with_token("http://localhost:3000/api/v1/challenges.json",
        config['token'])

      JSON.parse(response.body, symbolize_names: true)
    end

    def self.get_challenge(config, id)
      response = request_with_token("http://localhost:3000/api/v1/challenges/#{id}.json",
        config['token'])

      if response.code == '200'
        JSON.parse(response.body, symbolize_names: true)
      else
        nil
      end
    end

    def self.download_archive(download_link, dest)
      uri = URI(download_link)

      Net::HTTP.start(uri.host, uri.port) do |http|
        resp = http.get(uri.path)

        open(dest, 'wb') do |file|
          file.write(resp.body)
        end
      end

      dest
    end

    private

    def self.request_with_token(url, token)
      uri = URI(url)

      request = Net::HTTP::Get.new(uri)
      request['Authorization'] = "Token #{token}"
      response = Net::HTTP.start(uri.hostname, uri.port) do |http|
        http.request(request)
      end

      response
    end
  end
end
