module CliExampleGroup
  def self.included(base)
    base.class_eval do
      metadata[:type] = :cli

      let(:workdir) { Dir.mktmpdir('comet_test', '/tmp') }
      let(:config_file) { File.join(workdir, '.comet') }
      let(:comet_settings) { comet_settings_sample(workdir) }

      before :each do
        Comet::API.stub(:get_katas).and_return(katas_index_sample)
        Comet::API.stub(:get_kata)
        Comet::API.stub(:latest_gem_version).and_return('0.0.0')
        Comet::API.stub(:download_archive)

        File.write(config_file, comet_settings.to_yaml)
      end

      after :each do
        FileUtils.remove_entry_secure(workdir) if Dir.exists?(workdir)
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
