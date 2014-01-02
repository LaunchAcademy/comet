require 'rspec'
require 'tmpdir'
require 'yaml'
require 'mir'

describe Mir::Init do
  describe '.init_project_dir' do
    it 'creates a .mir file if doesnt already exist' do
      Dir.mktmpdir do |dir|
        config_file = File.join(dir, '.mir')
        expect(File.exists?(config_file)).to be_false

        Mir::Init.init_project_dir(dir)
        expect(File.exists?(config_file)).to be_true
      end
    end

    it 'creates placeholders for the user email and token' do
      Dir.mktmpdir do |dir|
        Mir::Init.init_project_dir(dir)

        config_file = File.join(dir, '.mir')
        config = YAML.load(File.read(config_file))

        expect(config.keys).to include('email')
        expect(config.keys).to include('token')
      end
    end
  end
end
