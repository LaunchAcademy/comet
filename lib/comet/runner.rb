require 'gli'
require 'yaml'
require 'helpers'
require 'openssl'
require 'shellwords'

module Comet
  class Runner
    extend GLI::App

    def self.go(args, cwd)
      program_desc 'Test your Ruby skills! Download Ruby exercises and submit your solutions for grading.'

      version Comet::VERSION

      desc 'Initialize the current directory as a comet project directory'
      skips_pre
      command :init do |c|
        c.action do |global_options, options, args|
          answers = Comet::Init.find_config(cwd) || {}

          ['email', 'token', 'server'].each do |setting|
            answers[setting] = prompt_for_setting(setting, answers)
          end

          Comet::Init.init_project_dir(cwd, answers)
        end
      end

      desc 'List the available challenges'
      command :list do |c|
        c.action do |global_options,options,args|
          challenges = Comet::Challenge.list(@config)

          if challenges.empty?
            puts "No challenges available."
          else
            challenges.each do |challenge|
              printf("(%4d) \e[34m%s\e[0m: %s (%s)\n",
                challenge[:id],
                challenge[:topic_name],
                challenge[:name],
                difficulty_to_string(challenge[:difficulty]))
            end
          end
        end
      end

      desc 'Download a challenge'
      command :fetch do |c|
        c.action do |global_options, options, args|
          challenge_id = args.first
          challenge = Comet::Challenge.find(@config, challenge_id)
          directory = challenge.download

          info_file = File.join(directory, '.kata')
          info = YAML.load(File.read(info_file))
          info['id'] = challenge_id.to_i

          File.write(info_file, info.to_yaml)

          puts "Downloaded kata to #{directory}."
        end
      end

      desc 'Run test suite'
      command :test do |c|
        c.action do |global_options, options, args|
          current_dir = cwd
          info_file = File.join(current_dir, '.kata')

          if File.exists?(info_file)
            kata_info = YAML.load(File.read(info_file))

            case kata_info['test_runner']
            when 'ruby'
              runner = 'ruby'
            when 'rspec'
              runner = 'rspec --color --fail-fast'
            else
              runner = 'ruby'
            end

            slug = File.basename(current_dir)
            test_file = File.join(current_dir, 'test', "#{slug}_test.rb")

            exec("#{runner} #{test_file}")
          else
            puts "Not a challenge directory."
          end
        end
      end

      desc 'Submit challenge'
      command :submit do |c|
        c.action do |global_options, options, args|
          require 'rest_client'
          require 'tmpdir'

          current_dir = cwd
          kata_file = File.join(current_dir, '.kata')

          if File.exists?(kata_file)
            kata_info = YAML.load(File.read(kata_file))
            lib_dir = File.join(current_dir, 'lib')
            slug = File.basename(current_dir)

            Dir.mktmpdir do |tmpdir|
              submission_file = File.join(tmpdir, 'submission.tar.gz')
              if system("tar zcf #{Shellwords.escape(submission_file)} -C #{Shellwords.escape(lib_dir)} .")
                payload = {
                  submission: {
                    challenge_id: kata_info['id'],
                    archive: File.new(submission_file)
                  }
                }

                headers = { 'Authorization' => "Token #{@config['token']}" }

                RestClient.post("#{@config['server']}/api/v1/submissions.json", payload, headers)

                puts "Submitted solution for #{slug}."
              else
                puts "Unable to create submission archive."
                exit 1
              end
            end

          else
            puts "Not a kata directory."
            exit 1
          end
        end
      end

      pre do |global,command,options,args|
        if Comet::Version.is_more_recent(Comet::API.latest_gem_version)
          $stderr.puts "\e[33mNOTICE: An updated version of comet exists. Run `gem update comet` to upgrade.\e[0m"
        end

        @config = Comet::Init.find_config(cwd)
        !@config.nil?
      end

      on_error do |exception|
        raise exception
      end

      run(args)
    end
  end
end
