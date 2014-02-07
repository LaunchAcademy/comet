require 'mir'

describe Mir::Challenge do

  let(:config) do
    {
      email: 'foo@example.com',
      token: '12345678',
      host: 'localhost:3000'
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

  let(:challenge_info) do
    {
      id: 1,
      name: 'Mini Golf',
      download_link: 'http://localhost:3000/downloads/challenges/mini_golf.tar.gz'
    }
  end

  describe '.find' do
    it 'returns a challenge with the given id' do
      expect(Mir::API).to receive(:get_challenge).and_return(challenge_info)

      challenge = Mir::Challenge.find(config, 1)

      expect(challenge.id).to eq(1)
      expect(challenge.name).to eq('Mini Golf')
    end

    it 'throws an exception if the challenge could not be found' do
      expect(Mir::API).to receive(:get_challenge).and_return(nil)
      expect {
        Mir::Challenge.find(config, 100)
      }.to raise_error(ArgumentError)
    end
  end

  describe '.list' do
    it 'returns a list of challenges' do
      expect(Mir::API).to receive(:get_challenges).and_return(challenge_list)

      challenges = Mir::Challenge.list(config)

      expect(challenges.size).to eq(3)
      expect(challenges[1][:name]).to eq("Mini Golf")
    end
  end
end
