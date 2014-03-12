require 'spec_helper'

describe 'invalid credentials' do
  context 'when an API request returns unauthorized' do
    let(:unauthorized_notice) do
      "Invalid credentials. Verify that the e-mail, token, and server " +
        "are correctly configured in #{File.join(work_dir, '.comet')}"
    end

    before :each do
      Comet::API.stub(:get_katas).and_raise(Comet::UnauthorizedError)
    end

    it 'displays a useful error message' do
      stdout, stderr = capture_output { Comet::Runner.go(['list'], work_dir) }
      expect(stderr).to include(unauthorized_notice)
    end
  end
end
