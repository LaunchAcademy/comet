module CliExampleGroup
  def self.included(base)
    base.class_eval do
      metadata[:type] = :cli

      let(:work_dir) { Dir.mktmpdir('comet_test', '/tmp') }
      let(:config_file) { File.join(work_dir, '.comet') }
      let(:comet_settings) { comet_settings_sample(work_dir) }

      let(:kata_dir) { File.join(work_dir, 'sample_kata') }

      before :each do
        Kernel.stub(:exec)
        Comet::API.stub(:get_katas).and_return(katas_index_sample)
        Comet::API.stub(:get_kata)
        Comet::API.stub(:latest_gem_version).and_return('0.0.0')
        Comet::API.stub(:download_archive)

        File.write(config_file, comet_settings.to_yaml)
      end

      after :each do
        FileUtils.remove_entry_secure(work_dir) if Dir.exists?(work_dir)
      end

      def copy_kata_to(dir)
        sample_kata = File.join(File.dirname(__FILE__),
          '../../data/sample_kata')
        FileUtils.cp_r(sample_kata, dir)
      end
    end
  end

  RSpec.configure do |config|
    config.include(self,
      :type => :cli,
      :example_group => { :file_path => %r(spec/cli) }
      )
  end
end
