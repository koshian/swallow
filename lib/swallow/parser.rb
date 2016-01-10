require 'strscan'

module Swallow
  class Parser
    SPACES = Regexp.new('\s+')
    TAG = Regexp.new('(<[^%?].*?[^%?]>)')
    BIGEN_COMMENT = Regexp.new('<!--\s*bigen\s*:\s*(.*)\s+-->')
    END_COMMENT = Regexp.new('<!--\s*end\s*:\s*(.*)\s+-->')
    NEXT_TAG = Regexp.new('.*?(?=<[^%?])')

    @tokens = Array.new

    def initialize(string)
      @source = string
    end

    def tokenize(source = @source)
      s = StringScanner.new(source)
      @tokens = Array.new
      until s.eos?
        if s.scan(SPACES)
          @tokens.push [' ', :space]
        elsif s.scan(TAG)
          case s[1]
          when BIGEN_COMMENT
            @tokens.push [$1, :bigen]
          when END_COMMENT
            @tokens.push [$1, :end]
          else
            @tokens.push [s[1], :tag]
          end
        elsif s.scan(NEXT_TAG)
          @tokens.push [s[0], :text]
        else
            raise 'Parse error'         
        end
      end
      @tokens
    end

    def parse(tokens = @tokens)
      $stdout.sync = true

      result = Array.new
      cache = Array.new
      flag = false

      i = 0
      j = tokens.size
      tokens.each do |token|
        if token[1] == :bigen
          flag = true

          if cache.size > 0
            result.concat cache
            cache = Array.new
          end

          result.push token[0]
          next
        end

        if token[1] == :end
          flag = false
          cache = Array.new
          next
        end

        if flag
          cache.push token[0]
        else
          result.push token[0]
        end
      end

      print_progress_bar('parsing...', i, j)
      i += 1

      result.concat cache if cache.size > 0
      result
    end

    def to_html(tokens = @tokens)
      @tokens.join('')
      #CGI.pretty(@tokens.join(''))
    end

    def print_progress_bar(name, progress, max)
      print "%s (%d/%d)" % name, progress, max
    end
  end
end
