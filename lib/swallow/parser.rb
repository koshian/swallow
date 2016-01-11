require 'strscan'

module Swallow
  class Parser
    LOOK_BEHIND_COMMENT_TAG =
      Regexp.new('.*?(?=<!--\s*(bigen|end)\s*:)', Regexp::MULTILINE)
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
        if s.scan(look_behind_comment_tag)
          @tokens.push [s[0], :text] if s[0].size > 0
          if s.scan(bigen_comment)
            @tokens.push [s[1], :bigen]
          else
            s.scan(end_comment)
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
          cache.clear
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
      CGI::pretty(self.parse(tokens).join('').to_s)
    end

    def look_behind_comment_tag
      LOOK_BEHIND_COMMENT_TAG
    end

    def bigen_comment
      BIGEN_COMMENT
    end

    def end_comment
      END_COMMENT
    end
  end

  class Ripper < Parser
    LOOK_BEHIND_COMMENT_TAG =
      Regexp.new('.*?(?=<!--\s*(bigen|end)-template\s*:)', Regexp::MULTILINE)
    BIGEN_COMMENT = Regexp.new('<!--\s*bigen-template\s*:\s*(.*?)\s+-->')
    END_COMMENT = Regexp.new('<!--\s*end-template\s*:\s*(.*?)\s+-->')

    @tokens = Array.new

    def parse(tokens = @tokens)
      result = Hash.new
      cache = Array.new
      name = nil

      tokens.each do |token|
        if token[1] == :bigen
          name = token[0]
        elsif token[1] == :end
          name = token[0] unless name
          cache.each do |c|
            result.has_key?(name) || result[name] = Array.new
            result[name].push c
          end
          cache.clear
        end

        unless name
          cache.push token[0]
        else
          result.has_key?(name) || result[name] = Array.new
          result[name].push token[0]
        end
      end

      result
    end

    def to_html(tokens = @tokens)
      self.parse(tokens).each do |name, content|
        content_string = content.join('')
        open(name, 'w'){|f| f.print content_string }
      end
    end

    def look_behind_comment_tag
      LOOK_BEHIND_COMMENT_TAG
    end

    def bigen_comment
      BIGEN_COMMENT
    end

    def end_comment
      END_COMMENT
    end
  end
end
