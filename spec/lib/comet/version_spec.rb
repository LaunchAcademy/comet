describe Comet::Version do

  describe '.build' do
    it 'combines the major, minor, and patch version in a string' do
      expect(Comet::Version.build(0, 2, 1)).to eq('0.2.1')
      expect(Comet::Version.build(10, 0, 13)).to eq('10.0.13')
    end
  end

  describe '.parse' do
    it 'extracts the major, minor, and patch number from a string' do
      major, minor, patch = Comet::Version.parse('1.2.3')

      expect(major).to eq(1)
      expect(minor).to eq(2)
      expect(patch).to eq(3)
    end
  end

  describe '.compare' do
    it 'compares the major version first' do
      expect(Comet::Version.compare('1.9.9', '2.0.0')).to eq(-1)
      expect(Comet::Version.compare('2.0.0', '1.9.9')).to eq(1)
      expect(Comet::Version.compare('2.0.0', '2.0.0')).to eq(0)
    end

    it 'compares the minor version second' do
      expect(Comet::Version.compare('2.1.9', '2.2.0')).to eq(-1)
      expect(Comet::Version.compare('2.2.10', '2.1.19')).to eq(1)
      expect(Comet::Version.compare('2.3.0', '2.3.0')).to eq(0)
    end

    it 'compares the patch version last' do
      expect(Comet::Version.compare('2.2.9', '2.2.10')).to eq(-1)
      expect(Comet::Version.compare('2.2.10', '2.2.9')).to eq(1)
      expect(Comet::Version.compare('2.3.1', '2.3.1')).to eq(0)
    end
  end

  describe '.is_more_recent' do
    it 'compares against the current version' do
      newer_version = Comet::Version.build(
        Comet::MAJOR_VERSION,
        Comet::MINOR_VERSION,
        Comet::PATCH_LEVEL + 1
        )

      older_version = Comet::Version.build(
        Comet::MAJOR_VERSION,
        Comet::MINOR_VERSION,
        Comet::PATCH_LEVEL - 1
        )

      expect(Comet::Version.is_more_recent(newer_version)).to eq(true)
      expect(Comet::Version.is_more_recent(older_version)).to eq(false)
      expect(Comet::Version.is_more_recent(Comet::VERSION)).to eq(false)
    end
  end
end
