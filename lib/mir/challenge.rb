class Mir::Challenge
  def self.list(config)
    Mir::API.get_challenges(config)
  end
end
