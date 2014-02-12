require 'yaml'

module Comet
  class Init
    class << self
      def find_config(dir)
        config_file = File.join(dir, '.comet')

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

      def init_project_dir(dirname, user_answers)
        config_file = File.join(dirname, '.comet')

        unless File.exists?(config_file)
          config = {
            'email' => user_answers['email'],
            'token' => user_answers['token'],
            'server' => normalize_url(user_answers['server'])
          }

          File.write(config_file, config.to_yaml)
        end
      end

      private

      def normalize_url(input)
        unless input.include?('://')
          'http://' + input
        else
          input
        end
      end
    end
  end
end
