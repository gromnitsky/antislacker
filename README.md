# antislacker

Chrome 33+ extension.

An antiprocrastinator. Blocks domains after a time limit until the next
day.

## How It Works

User has a list of (sub)domains (not URIs). Antislacker checks if tab's
url matches one from the user list & injects a chunk of JS code with a
counter into that tab. If the counter reaches user's preferred limit,
then matched domain is blocked until the beginning of the next day.

![options page](https://raw.github.com/gromnitsky/antislacker/master/ss-options.png)

## Download & Install

For a latest .crx file look
[here](http://gromnitsky.users.sourceforge.net/js/chrome/).

Save the file, then open Chrome's extensions page (`Alt-F`
`Tools->Extensions`) and drag & drop the file into the page.

## Build requirements:

* in global mode:
  * make-commonjs-depend
  * coffee-script 1.7.1+
  * bower
* GNU m4
* xxd utility.
* GNU make.

## Compilation

To compile, run

	$ make depend
    $ make compile

To make a .crx file, you'll need a private RSA key named `private.pem`
in the same directory where Makefile is. For testing purposes, generate
it with openssl:

    $ openssl genrsa -out private.pem 1024

and run:

    $ make crx

If everything was fine, `antislacker-x.y.z.crx` file will
appear.

## Test

There are 2 kinds of separate tests: those who run in node & in
browser. For the 1st one just type:

	$ make

For the 2nd you'll need an http server. For example:

	$ python -m SimpleHTTPServer

& go to http://0.0.0.0:8000/test/browser/test_options.html

## License

MIT.

The icon is from [openclipart](http://openclipart.org/detail/192476/).
