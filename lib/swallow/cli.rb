module Swallow
  class CLI
    def self.cat_file
      ARGV.size < 1 && self.help
      file = File.exist?(ARGV[0]) ? open(ARGV[0]).read : STDIN.read
      file.size <= 0 && self.help
      file
    end

    def self.start
      file = cat_file
      self.parse(file)
    end

    def self.rip_start
      file = cat_file
      self.rip(file)
    end

    def self.help
      STDERR.puts "Usage: " + File.basename($PROGRAM_NAME) + ' source_file'
      exit
    end

    def self.parse(file)
      print Swallow.parse(file)
    end

    def self.rip(file)
      Swallow.rip(file)
    end
  end
end
