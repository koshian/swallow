require 'spec_helper'

describe Swallow do
  it 'has a version number' do
    expect(Swallow::VERSION).not_to be nil
  end

  it 'Tokenize test 1' do
    src = '<!-- bigen: <%= variable %> -->'
    rst = [['<%= variable %>', :bigen]]

    test_token_expect(src, rst)
  end

  it 'Tokenize test 2' do
    src = '<!-- bigen: <?php echo $variable ?> -->'
    rst = [['<?php echo $variable ?>', :bigen]]

    test_token_expect(src, rst)
  end

  it 'Tokenize test 4' do
    src = '<!-- bigen: variable --> Done is better than perfect. <!-- end: variable -->'
    rst = [['variable', :bigen],
           [' Done is better than perfect. ', :text],
           ['variable', :end]]
    test_token_expect(src, rst)
  end

  it 'Tokenize test 5' do
    src = '<!-- bigen: variable --> Done is <strong>better</strong> than perfect. <!-- end: variable -->'
    rst = [['variable', :bigen],
           [' Done is ', :text],
           ['<strong>', :tag],
           ['better', :text],
           ['</strong>', :tag],
           [' than perfect. ', :text],
           ['variable', :end]]
    test_token_expect(src, rst)
  end

  # it 'Tokenize test 99' do
  #   src = '<!-- begin-template: template-name --> <span>Done is better than perfect. </span> <!-- end-template: variable -->'
  #   rst = {'type' => 'template', 'name' => ' <span>Done is better than perfect. </span> '}
  #   test_token_expect(src, rst)
  # end

  it 'Parse test 1' do
    src = [['<?php echo $variable ?>', :bigen],
           [' Done is better than perfect. ', :text],
           ['<?php echo $variable ?>', :end]]
    rst = ['<?php echo $variable ?>']
    test_parse_expect(src, rst)
  end

  it 'Parse test 2' do
    src = [['<?php echo $variable ?>', :bigen],
           [' Done is better than perfect. ', :text]]
    rst = ['<?php echo $variable ?>', ' Done is better than perfect. ']
    test_parse_expect(src, rst)
  end
end
