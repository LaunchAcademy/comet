require 'rspec'
require 'tmpdir'
require 'yaml'
require 'mir'

describe Mir::Init do
  let(:settings) do
    {
    'email' => 'foo@example.com',
    'token' => 'foobarbaz'
    }
  end

  describe '.find_config' do
    it 'loads the config file in the given dir' do
      Dir.mktmpdir do |dir|
        config_file = File.join(dir, '.mir')
        File.write(config_file, settings.to_yaml)

        config = Mir::Init.find_config(dir)

        expect(config['email']).to eq('foo@example.com')
        expect(config['token']).to eq('foobarbaz')
      end
    end

    it 'checks parent directories for the config file' do
      Dir.mktmpdir do |parent_dir|
        config_file = File.join(parent_dir, '.mir')
        File.write(config_file, settings.to_yaml)

        child_dir = File.join(parent_dir, 'child')
        Dir.mkdir(child_dir)

        config = Mir::Init.find_config(child_dir)

        expect(config['email']).to eq('foo@example.com')
        expect(config['token']).to eq('foobarbaz')
      end
    end
  end

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
      Dir.mktmpdir do |dir|
        config_file = File.join(dir, '.mir')
        File.write(config_file, settings.to_yaml)

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
