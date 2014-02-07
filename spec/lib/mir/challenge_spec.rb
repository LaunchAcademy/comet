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

  describe '.list' do
    it 'returns a list of challenges' do
      expect(Mir::API).to receive(:get_challenges).and_return(challenge_list)

      challenges = Mir::Challenge.list(config)

      expect(challenges.size).to eq(3)
      expect(challenges[1][:name]).to eq("Mini Golf")
    end
  end
end
