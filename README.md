Spinto Ruby Gem
---------------

[Spinto](http://www.spintoapp.com) is a CMS alternative for
building websites with non-technical contributors over Git.
The site builder on Spinto's server is a flavor
of [Jekyll](https://github.com/mojombo/jekyll), with added
support for [CoffeeScript](http://coffeescript.org/),
[LESS](http://lesscss.org/),
[SASS and SCSS](http://sass-lang.com/).

The Spinto Ruby Gem comes with a server to build and preview
your website on your own computer. Open a terminal and `cd`
into a Spinto/Jekyll project, and start the server:

``` bash
spinto-site --auto --server
```

Now you can open a browser to [http://localhost:4000](http://localhost:4000)
and see your website. The `--auto` flag will ensure your
website is rebuilt when files are changed.

```
> spinto-site --help
Spinto-site is the spintoapp.com wrapper of jekyll,
the blog-aware, static site generator.

Basic Command Line Usage:
  spinto-site                                                  # . -> ./_site
  spinto-site <path to write generated site>                   # . -> <path>
  spinto-site <path to source> <path to write generated site>  # <path> -> <path>
  spinto-site --auto --server                                  # Host your site locally
  
  Configuration is read from '<source>/_config.yml' but can be overriden
  using the following options:

        --[no-]auto                  Auto-regenerate
        --server [PORT]              Start web server (default port 4000)
        --no-server                  Do not start a web server
        --url [URL]                  Set custom site.url
        --version                    Display current version
```

**Installation**

``` bash
gem install spinto
```

And you're done!

**Additional Info**

The Spinto Ruby Gem is available under the MIT License.

Written by [Matthew Beale](matt.beale@madhatted.com) for [Spinto](http://www.spintoapp.com).

