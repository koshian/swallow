require "swallow/version"
require "swallow/cli"
require "swallow/parser"
require 'cgi'

module Swallow
  def parse(string)
    p = Parser.new(string)
    p.to_html
  end
end
