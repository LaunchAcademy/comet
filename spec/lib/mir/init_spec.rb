require 'rspec'
require 'tmpdir'
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
  end
end
