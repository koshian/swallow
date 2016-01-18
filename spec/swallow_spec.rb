require 'spec_helper'

describe Swallow do
  it 'has a version number' do
    expect(Swallow::VERSION).not_to be nil
  end

  it 'Tokenize test 1' do
    src = '<!-- begin: <%= variable %> -->'
    rst = [['<%= variable %>', :begin]]

    test_token_expect(src, rst)
  end

  it 'Tokenize test 2' do
    src = '<!-- begin: <?php echo $variable ?> -->'
    rst = [['<?php echo $variable ?>', :begin]]

    test_token_expect(src, rst)
  end

  it 'Tokenize test 4' do
    src = '<!-- begin: variable --> Done is better than perfect. <!-- end: variable -->'
    rst = [['variable', :begin],
           ["Done is better than perfect.", :text],
           ['variable', :end]]
    test_token_expect(src, rst)
  end

  it 'Tokenize test 5' do
    src = '<!-- begin: variable --> Done is <strong>better</strong> than perfect. <!-- end: variable -->'
    rst = [['variable', :begin],
           ['Done is 
<strong>
  better
</strong>
 than perfect.', :text],
           ['variable', :end]]
    test_token_expect(src, rst)
  end

  it 'Tokenize test 6' do
    src = '<p>Done is better than perfect.</p>'
    rst = [['<p>
  Done is better than perfect.
</p>
', :text]]
    test_token_expect(src, rst)
  end

  it 'Tokenize test 7' do
    src = '<!-- begin:
                  variable
             -->
             Done is better than perfect.
           <!-- end:
                  variable
              -->'
    rst = [['variable', :begin],
           ['Done is better than perfect.', :text],
           ['variable', :end]]
    test_token_expect(src, rst)
  end

  it 'Tokenize test 8' do
    src = '<!-- begin-template: variable --> Done is better than perfect. <!-- end-template: variable -->'
    rst = [['variable', :begin],
           ["\n Done is better than perfect. \n", :text],
           ['variable', :end],
           ["\n", :text]]
    test_ripper_token_expect(src, rst)
  end

  it 'Tokenize test 9' do
    src = '<html>
             <title>Done is better than perfect.</title>
             <body>
             <!-- end-template: header.html -->
             <!-- begin-template: body.html -->
               <h1>Done is better than perfect.</h1>
               <!-- begin-template: footer.html -->
               <hr>
               <address>user@example.org</address>
             </body>
           </html>'
    rst = [["<html>
  <title>
    Done is better than perfect.
  </title>
  <body>
    ", :text],
           ["header.html", :end],
           ["\n    ", :text],
           ["body.html", :begin],
           ["
    <h1>
      Done is better than perfect.
    </h1>
    ", :text],
           ["footer.html", :begin],
           ["
    <hr>
    <address>
      user@example.org
    </address>
  </body>
</html>
", :text]]
    test_ripper_token_expect(src, rst)
  end

  it 'Tokenize test 10' do
    src = '<html>
             <title>Done is better than perfect.</title>
             <body>
             <!-- begin-template: body2.html -->
               <h1>Done is better than perfect.</h1>
               <!-- begin-template: footer2.html -->
               <hr>
               <address>user@example.org</address>
               <!-- end-template: footer2.html -->
             </body>
           </html>'
    rst = [["<html>
  <title>
    Done is better than perfect.
  </title>
  <body>
    ", :text],
           ["body2.html", :begin],
           ["
    <h1>
      Done is better than perfect.
    </h1>
    ", :text],
           ["footer2.html", :begin],
           ["
    <hr>
    <address>
      user@example.org
    </address>
    ", :text],
           ["footer2.html", :end],
           ["
  </body>
</html>
", :text]]
    test_ripper_token_expect(src, rst)
  end

  it 'Parse test 1' do
    src = [['<?php echo $variable ?>', :begin],
           [' Done is better than perfect. ', :text],
           ['<?php echo $variable ?>', :end]]
    rst = ['<?php echo $variable ?>']
    test_parse_expect(src, rst)
  end

  it 'Parse test 2' do
    src = [['<?php echo $variable ?>', :begin],
           [' Done is better than perfect. ', :text]]
    rst = ['<?php echo $variable ?>', ' Done is better than perfect. ']
    test_parse_expect(src, rst)
  end

  it 'Parse test 3' do
    src = [['<p>Done is better than perfect.</p>', :text]]
    rst = ['<p>Done is better than perfect.</p>']
    test_parse_expect(src, rst)
  end


  it 'File exist test 1' do
    src = '<html>
             <title>Done is better than perfect.</title>
             <body>
             <!-- end-template: header.html -->
             <!-- begin-template: body.html -->
               <h1>Done is better than perfect.</h1>
               <!-- begin-template: footer.html -->
               <hr>
               <address>user@example.org</address>
             </body>
           </html>'
    Swallow.rip(src)
    File.exist?('header.html').should == true
    File.exist?('body.html').should == true
    File.exist?('footer.html').should == true
  end

  it 'Generate layout test 1' do
    src = '<html>
             <title>Done is better than perfect.</title>
             <body>
             <!-- begin-template: body2.html -->
               <h1>Done is better than perfect.</h1>
               <!-- begin-template: footer2.html -->
               <hr>
               <address>user@example.org</address>
               <!-- end-template: footer2.html -->
             </body>
           </html>'
    Swallow.rip(src)
    File.exist?('layout.html').should == true
    File.exist?('body.html').should == true
    File.exist?('footer.html').should == true
  end
end
