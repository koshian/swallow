require "swallow/version"
require "swallow/cli"
require "swallow/parser"
require 'cgi'

module Swallow
  def self.parse(string)
    p = Parser.new(string)
    p.tokenize
    p.to_html
  end

  def self.rip(string)
    p = Ripper.new(string)
    p.tokenize
    p.to_html
  end
end
