require 'spec_helper'
require 'tmpdir'
require 'yaml'
require 'comet'

describe 'check for update' do
  let(:tmpdir) { Dir.mktmpdir('comet_test', '/tmp') }
  let(:config_file) { File.join(tmpdir, '.comet') }

  let(:comet_settings) do
    {
      'email' => 'barry.zuckerkorn@example.com',
      'token' => 'abcdefghijklmnopqrstuv12345678',
      'server' => 'http://localhost:3000',
      'basedir' => tmpdir
    }
  end

  let(:challenge_list) do
    [{
        id: 1,
        name: "Calculator"
      },
      {
        id: 2,
        name: "Mini Golf"
      },
      {
        id: 3,
        name: "Sum Of Integers"
      }]
  end

  before :each do
    Comet::API.stub(:get_challenges).and_return(challenge_list)
    File.write(config_file, comet_settings.to_yaml)
  end

  after :each do
    FileUtils.remove_entry_secure(tmpdir) if Dir.exists?(tmpdir)
  end

  context 'when a newer version exists' do
    before :each do
      Comet::API.stub(:latest_gem_version).and_return('0.0.8')
    end

    let(:notice) do
      'NOTICE: An updated version of comet exists. Run `gem update comet` to upgrade.'
    end

    it 'notifies user to update the gem' do
      stdout, stderr = capture_output { Comet::Runner.go(['list'], tmpdir) }
      expect(stderr).to include(notice)
    end
  end
end
