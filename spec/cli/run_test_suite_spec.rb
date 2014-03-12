require 'spec_helper'

describe 'running test suite' do

  let(:rspec_command) { "rspec --color --fail-fast" }
  let(:test_file) { File.join(kata_dir, 'test/sample_kata_test.rb') }

  before :each do
    copy_kata_to(kata_dir)
  end

  context 'when in a kata directory' do
    it 'runs rspec on the test directory' do
      expect(Kernel).to receive(:exec).with("#{rspec_command} #{test_file}")
      stdout, stderr = capture_output { Comet::Runner.go(['test'], kata_dir) }
    end
  end

  context 'when in a kata subdirectory' do
    let(:subdir) { File.join(kata_dir, 'test') }

    it 'runs rspec on the test directory' do
      expect(Kernel).to receive(:exec).with("#{rspec_command} #{test_file}")
      stdout, stderr = capture_output { Comet::Runner.go(['test'], subdir) }
   end
  end

  context 'when not in a kata directory' do
    let(:notice) { 'Not a kata directory.' }

    it 'notifies the user that it is not a kata directory' do
      expect(Kernel).to_not receive(:exec)

      parent_dir = File.dirname(kata_dir)
      stdout, stderr = capture_output do
        Comet::Runner.go(['test'], parent_dir)
      end

      expect(stderr).to include(notice)
    end
  end
end
