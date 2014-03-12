require 'tmpdir'
require 'comet'

describe Comet::Kata do

  let(:basedir) { '/tmp' }

  let(:config) do
    {
      email: 'foo@example.com',
      token: '12345678',
      host: 'localhost:3000'
    }
  end

  let(:kata) do
    Comet::Kata.new({
        id: 1,
        name: 'Mini Golf',
        slug: 'mini_golf',
        download_link: 'http://localhost:3000/downloads/katas/mini_golf.tar.gz',
        basedir: basedir
      })
  end

  let(:kata_info) do
    {
      id: 1,
      name: 'Mini Golf',
      download_link: 'http://localhost:3000/downloads/katas/mini_golf.tar.gz'
    }
  end

  let(:kata_list) do
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

  describe '.find' do
    it 'returns a kata with the given id' do
      expect(Comet::API).to receive(:get_kata).and_return(kata_info)

      kata = Comet::Kata.find(config, 1)

      expect(kata.id).to eq(1)
      expect(kata.name).to eq('Mini Golf')
    end

    it 'throws an exception if the kata could not be found' do
      expect(Comet::API).to receive(:get_kata).and_return(nil)
      expect {
        Comet::Kata.find(config, 100)
      }.to raise_error(ArgumentError)
    end
  end

  describe '.list' do
    it 'returns a list of katas' do
      expect(Comet::API).to receive(:get_katas).and_return(kata_list)

      katas = Comet::Kata.list(config)

      expect(katas.size).to eq(3)
      expect(katas[1][:name]).to eq("Mini Golf")
    end
  end

  describe '#download' do
    let(:basedir) { Dir.mktmpdir }

    let(:test_archive) do
      File.expand_path(File.join(File.dirname(__FILE__), '../../data/mini_golf.tar.gz'))
    end

    it 'downloads and unpacks kata in the base directory' do
      expect(Comet::API).to receive(:download_archive)
        .with(kata.download_link, File.join(basedir, 'mini_golf.tar.gz')) do

        FileUtils.copy(test_archive, basedir)
        File.join(basedir, 'mini_golf.tar.gz')
      end

      kata.download

      files = ['README.md', 'mini_golf.rb', 'mini_golf_test.rb']
      files.each do |file|
        expect(File).to exist(File.join(basedir, 'mini_golf', file))
      end
    end
  end
end
