# Swallow

Swallow parse a html with begin/end comments. like this.

```html
<html>
  <title>Done is better than perfect.</title>
   <body>
     <h1>Done is better than perfect.</h1>
     <article>
       <!-- begin: <%= yeild %> -->
       <p>test article</p>
       <!-- end: <%= yeild %> -->
     </article>
     <hr>
     <address>user@example.org</address>
   </body>
</html>
```
    $ swallow example1.html

then you can get this:

```html
<html>
  <title>
    Done is better than perfect.
  </title>
  <body>
    <h1>
      Done is better than perfect.
    </h1>
    <article>

      <%= yeild %>
           
    </article>
    <hr>
    <address>
      user@example.org
    </address>
  </body>
</html>
```

And also like this:

```html
<html>
  <title>Done is better than perfect.</title>
   <body>
   <!-- end-template: header.html -->
   <!-- begin-template: body.html -->
     <h1>Done is better than perfect.</h1>
     <!-- begin-template: footer.html -->
     <hr>
     <address>user@example.org</address>
   </body>
</html>
```
    $ swallow-rip example2.html

then you can get this:

    $ ls *.html
    body.html       footer.html     header.html

###### body.html
```html
<h1>Done is better than perfect.</h1>
```
###### footer.html
```html
     <hr>
     <address>user@example.org</address>
   </body>
</html>
```
###### header.html
```html
<html>
  <title>Done is better than perfect.</title>
   <body>
```

And swallow-rip can generate Rails like layout.html.

```html
<html>
  <title>Done is better than perfect.</title>
  <body>
  <!-- begin-template: body.html -->
    <h1>Done is better than perfect.</h1>
    <!-- begin-template: footer.html -->
    <hr>
    <address>user@example.org</address>
    <!-- end-template: footer.html -->
  </body>
</html>
```
    $ ls *.html
    body.html       footer.html     layout.html

###### body.html
```html
<h1>Done is better than perfect.</h1>
```
###### footer.html
```html

    <hr>
    <address>user@example.org</address>
```
###### layout.html
```html
<html>
  <title>Done is better than perfect.</title>
  <body>
  
  </body>
</html>
```

## Installation

Add this line to your application's Gemfile:

    $ git clone git@github.com:koshian/swallow.git
    $ cd swallow
    $ bundle exec rake build
    $ gem install -l pkg/swallow-*.gem

## Usage

TODO: Write usage instructions here

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/koshian/swallow.

