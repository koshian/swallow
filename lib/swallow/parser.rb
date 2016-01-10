require 'strscan'

module Swallow
  class Parser
    @tokens = Array.new

    def initialize(string)
      @source = string
    end

    def tokenize(source = @source)
      s = StringScanner.new(source)
      @tokens = Array.new
      until s.eos?
        if s.scan(/(<[^%?].*?[^%?]>)/)
          case s[1]
          when /<!--\s*bigen\s*:\s*(.*)\s+-->/
            @tokens.push [$1, :bigen]
          when /<!--\s*end\s*:\s*(.*)\s+-->/
            @tokens.push [$1, :end]
          else
            @tokens.push [s[1], :tag]
          end
        elsif s.scan(/.*?(?=<[^%?])/)
          @tokens.push [s[0], :text]
        else
            raise 'Parse error'         
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
      CGI.pretty(@tokens.join(''))
    end
  end
end
