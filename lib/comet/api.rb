require 'net/http'
require 'json'
require 'rest-client'

module Comet
  class API
    RUBYGEMS_URL = 'https://rubygems.org/api/v1/gems/comet.json'

    def self.latest_gem_version
      results = JSON.parse(RestClient.get(RUBYGEMS_URL))
      results['version']
    end

    def self.get_katas(config)
      response = request_with_token("#{config['server']}/api/v1/challenges.json",
        config['token'])

      results = JSON.parse(response.body, symbolize_names: true)
      results[:challenges]
    end

    def self.get_kata(config, id)
      response = request_with_token("#{config['server']}/api/v1/challenges/#{id}.json",
        config['token'])

      if response.code == '200'
        results = JSON.parse(response.body, symbolize_names: true)
        results[:challenge]
      else
        nil
      end
    end

    def self.download_archive(download_link, dest)
      uri = URI(download_link)

      Net::HTTP.start(uri.host, uri.port,
        use_ssl: uri.scheme == 'https') do |http|

        resp = http.get(uri.path)

        open(dest, 'wb') do |file|
          file.write(resp.body)
        end
      end

      dest
    end

    def self.submit(config, kata_id, file_path)
      uri = URI("#{config['server']}/api/v1/submissions.json")
      req = Net::HTTP::Post.new(uri)

      file_name = File.basename(file_path)
      body = File.read(file_path)

      req['Authorization'] = "Token #{config['token']}"

      req.set_form_data({
          'submission[challenge_id]' => kata_id,
          'submission[file_name]' => file_name,
          'submission[body]' => body
        })

      res = Net::HTTP.start(uri.hostname, uri.port) do |http|
        http.request(req)
      end
    end

    private

    def self.request_with_token(url, token)
      begin
        RestClient.get(url, { 'Authorization' => "Token #{token}" })
      rescue RestClient::Unauthorized => e
        raise Comet::UnauthorizedError
      end
    end
  end
end
