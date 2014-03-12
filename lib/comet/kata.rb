require 'shellwords'

class Comet::Kata
  attr_reader :id, :name, :slug, :download_link, :basedir

  def initialize(params)
    @id = params[:id]
    @name = params[:name]
    @slug = params[:slug]
    @download_link = params[:download_link]
    @basedir = params[:basedir]
  end

  def download
    archive = Comet::API.download_archive(download_link, File.join(basedir, "#{slug}.tar.gz"))
    `tar zxf #{Shellwords.escape(archive)} -C #{Shellwords.escape(basedir)}`
    File.delete(archive)
    File.join(basedir, slug)
  end

  def self.list(config)
    Comet::API.get_katas(config)
  end

  def self.find(config, id)
    kata_info = Comet::API.get_kata(config, id)

    if kata_info.nil?
      raise ArgumentError.new("Could not find kata with id = #{id}")
    else
      Comet::Kata.new(kata_info.merge({ basedir: config['basedir'] }))
    end
  end

  def self.find_kata_dir(dir)
    kata_file = File.join(dir, '.kata')

    if File.exists?(kata_file)
      kata_file
    else
      parent_dir = File.dirname(dir)

      if parent_dir != '/' && parent_dir != '.'
        find_kata_dir(parent_dir)
      else
        nil
      end
    end
  end
end
