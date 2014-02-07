class Mir::Challenge
  attr_reader :id, :name

  def initialize(id, name)
    @id = id
    @name = name
  end

  class << self
    def list(config)
      Mir::API.get_challenges(config)
    end

    def find(config, id)
      challenge_info = Mir::API.get_challenge(config, id)

      if challenge_info.nil?
        raise ArgumentError.new("Could not find challenge with id = #{id}")
      else
        Mir::Challenge.new(challenge_info[:id], challenge_info[:name])
      end
    end
  end
end
