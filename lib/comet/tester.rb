require 'yaml'

class Comet::Tester
  def self.run_test_suite(kata_file)
    kata_info = YAML.load(File.read(kata_file))
    runner = test_runner_command(kata_info['test_runner'])

    kata_dir = File.dirname(kata_file)
    slug = File.basename(kata_dir)
    test_file = File.join(kata_dir, 'test', "#{slug}_test.rb")

    Kernel.exec("#{runner} #{test_file}")
  end

  private

  def self.test_runner_command(key)
    case key
    when 'ruby'
      'ruby'
    when 'rspec'
      'rspec --color --fail-fast'
    else
      key
    end
  end
end
