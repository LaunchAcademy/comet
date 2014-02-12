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

        if File.exists?(config_file)
          existing_settings = YAML.load(File.read(config_file))
        else
          existing_settings = {}
        end

        settings = existing_settings.merge(user_answers)
        settings['server'] = normalize_url(settings['server']) if settings['server']

        File.write(config_file, settings.to_yaml)
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
