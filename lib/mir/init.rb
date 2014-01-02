module Mir
  class Init
    class << self
      def init_project_dir(dirname)
        config_file = File.join(dirname, '.mir')
        File.write(config_file, 'test')
      end
    end
  end
end
