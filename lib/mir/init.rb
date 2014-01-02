require 'yaml'

module Mir
  class Init
    class << self
      def init_project_dir(dirname)
        config_file = File.join(dirname, '.mir')
        config = {
          'email' => 'EMAIL GOES HERE...',
          'token' => 'TOKEN GOES HERE...'
        }

        File.write(config_file, config.to_yaml)
      end
    end
  end
end
