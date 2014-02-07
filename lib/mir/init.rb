require 'yaml'

module Mir
  class Init
    class << self
      def find_config(dir)
        config_file = File.join(dir, '.mir')

        if File.exists?(config_file)
          config = YAML.load(File.read(config_file))
          config.merge({ 'basedir' => dir })
        else
          parent_dir = File.dirname(dir)

          if parent_dir != '/' && parent_dir != '.'
            find_config(parent_dir)
          else
            nil
          end
        end
      end

      def init_project_dir(dirname)
        config_file = File.join(dirname, '.mir')

        unless File.exists?(config_file)
          config = {
            'email' => 'EMAIL GOES HERE...',
            'token' => 'TOKEN GOES HERE...'
          }

          File.write(config_file, config.to_yaml)
        end
      end

      private


    end
  end
end
