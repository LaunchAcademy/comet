require 'spec_helper'

describe 'check for update' do

  let(:update_notice) do
    'NOTICE: An updated version of comet exists. ' +
      'Run `gem update comet` to upgrade.'
  end

  context 'when a newer version exists' do
    let(:next_version) do
      Comet::Version.build(
        Comet::MAJOR_VERSION,
        Comet::MINOR_VERSION,
        Comet::PATCH_LEVEL + 1)
    end

    before :each do
      Comet::API.stub(:latest_gem_version).and_return(next_version)
    end

    it 'notifies user to update the gem' do
      stdout, stderr = capture_output { Comet::Runner.go(['list'], workdir) }
      expect(stderr).to include(update_notice)
    end

    it 'does not notify the user when running a test suite' do
      stdout, stderr = capture_output { Comet::Runner.go(['test'], workdir) }
      expect(stderr).to_not include(update_notice)
    end
  end

  context 'when the current version is up-to-date' do
    before :each do
      Comet::API.stub(:latest_gem_version).and_return(Comet::VERSION)
    end

    it 'does not notify user to update the gem' do
      stdout, stderr = capture_output { Comet::Runner.go(['list'], workdir) }
      expect(stderr).to_not include(update_notice)
    end

  end
end
