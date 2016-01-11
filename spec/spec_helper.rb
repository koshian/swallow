$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'swallow'

def test_token_expect(src, result)
  s = Swallow::Parser.new(src)
  expect(s.tokenize).to eq(result)
end

def test_ripper_token_expect(src, result)
  s = Swallow::Ripper.new(src)
  expect(s.tokenize).to eq(result)
end

def test_parse_expect(src, result)
  s = Swallow::Parser.new(String.new)
  expect(s.parse(src)).to eq(result)
end

