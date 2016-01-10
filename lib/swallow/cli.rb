module Swallow
  class CLI
    def self.start
      file = File.exist?(ARGV[0]) ? open(ARGV[0]).read : STDIN.read
      file.size <= 0 && self.help
      self.parse(file)
    end

    def self.help
      STDERR.puts "Usage: " + File.basename($PROGRAM_NAME) + ' source_file'
    end

    def self.parse(file)
      p Swallow::Parser.tokenize(file)
    end
  end
end
