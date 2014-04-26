# antislacker

Chrome 33+ extension.

TODO: write a description

## Build requirements:

* jsontool in global mode.
* make-commonjs-depend in global mode.
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

& go to http://localhost:8000/test/browser/options.html

## License

MIT.
