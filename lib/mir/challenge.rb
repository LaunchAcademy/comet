class Mir::Challenge
  attr_reader :id, :name, :slug, :download_link, :basedir

  def initialize(params)
    @id = params[:id]
    @name = params[:name]
    @slug = params[:slug]
    @download_link = params[:download_link]
    @basedir = params[:basedir]
  end

  def download
    archive = Mir::API.download_archive(download_link, File.join(basedir, "#{slug}.tar.gz"))
    `tar zxf #{archive} -C #{basedir}`
    File.delete(archive)
    File.join(basedir, slug)
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
        Mir::Challenge.new(challenge_info.merge({ basedir: config['basedir'] }))
      end
    end
  end
end
