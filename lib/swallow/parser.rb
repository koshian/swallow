require 'strscan'

module Swallow
  class Parser
    LOOK_BEHIND_COMMENT_TAG = Regexp.new('.*?(?=<!--\s*(bigen|end)\s*:)',
                                         Regexp::MULTILINE)
    BIGEN_COMMENT = Regexp.new('<!--\s*bigen\s*:\s*(.*?)\s+-->')
    END_COMMENT = Regexp.new('<!--\s*end\s*:\s*(.*?)\s+-->')

    @tokens = Array.new

    def initialize(string)
      @source = string
    end

    def tokenize(source = @source)
      s = StringScanner.new(source)
      @tokens = Array.new
      until s.eos?
        if s.scan(LOOK_BEHIND_COMMENT_TAG)
          @tokens.push [s[0], :text] if s[0].size > 0
          if s.scan(BIGEN_COMMENT)
            @tokens.push [s[1], :bigen]
          else
            s.scan(END_COMMENT)
            @tokens.push [s[1], :end]
          end
        else
          @tokens.push [s.rest, :text]
          s.terminate
        end
      end
      @tokens
    end

    def parse(tokens = @tokens)
      result = Array.new
      cache = Array.new
      flag = false

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

      result.concat cache if cache.size > 0
      result
    end

    def to_html(tokens = @tokens)
      # p self.parse(tokens).join('')
      CGI::pretty(self.parse(tokens).join('').to_s)
      #self.parse(tokens).join('')
      # tokens.join('')
      #CGI.pretty(@tokens.join(''))
    end
  end
end
