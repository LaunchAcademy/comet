module Comet
  class Version
    def self.build(major, minor, patch)
      "#{major}.#{minor}.#{patch}"
    end

    def self.parse(string)
      version_levels = string.split('.').map { |version| version.to_i }
      [version_levels[0], version_levels[1], version_levels[2]]
    end

    def self.compare(version_a, version_b)
      a_major, a_minor, a_patch = parse(version_a)
      b_major, b_minor, b_patch = parse(version_b)

      if a_major > b_major
        1
      elsif a_major < b_major
        -1
      else
        if a_minor > b_minor
          1
        elsif a_minor < b_minor
          -1
        else
          if a_patch > b_patch
            1
          elsif a_patch < b_patch
            -1
          else
            0
          end
        end
      end
    end

    def self.is_more_recent(other_version)
      compare(VERSION, other_version) < 0
    end
  end

  MAJOR_VERSION = 0
  MINOR_VERSION = 0
  PATCH_LEVEL = 7

  VERSION = Version.build(MAJOR_VERSION, MINOR_VERSION, PATCH_LEVEL)
end
