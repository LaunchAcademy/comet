require 'net/http'
require 'json'

module Comet
  class API
    def self.get_challenges(config)
      response = request_with_token("#{config['server']}/api/v1/challenges.json",
        config['token'])

      results = JSON.parse(response.body, symbolize_names: true)
      results[:challenges]
    end

    def self.get_challenge(config, id)
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

    def self.submit(config, challenge_id, file_path)
      uri = URI("#{config['server']}/api/v1/submissions.json")
      req = Net::HTTP::Post.new(uri)

      file_name = File.basename(file_path)
      body = File.read(file_path)

      req['Authorization'] = "Token #{config['token']}"

      req.set_form_data({
          'submission[challenge_id]' => challenge_id,
          'submission[file_name]' => file_name,
          'submission[body]' => body
        })

      res = Net::HTTP.start(uri.hostname, uri.port) do |http|
        http.request(req)
      end
    end

    private

    def self.request_with_token(url, token)
      uri = URI(url)

      request = Net::HTTP::Get.new(uri.request_uri)
      request['Authorization'] = "Token #{token}"
      response = Net::HTTP.start(uri.hostname, uri.port) do |http|
        http.request(request)
      end

      response
    end
  end
end
