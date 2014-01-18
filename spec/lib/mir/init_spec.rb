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

    it 'does not overwrite an existing file' do
      existing_settings = {
        'email' => 'foo@example.com',
        'token' => 'foobarbaz'
      }

      Dir.mktmpdir do |dir|
        config_file = File.join(dir, '.mir')
        File.write(config_file, existing_settings.to_yaml)

        Mir::Init.init_project_dir(dir)
        current_settings = YAML.load(File.read(config_file))

        expect(current_settings['email']).to eq('foo@example.com')
        expect(current_settings['token']).to eq('foobarbaz')
      end
    end

    it 'adds missing settings to config file'
    it 'errors when the config file is not in correct format'
  end
end
