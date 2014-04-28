# WARNING: run ../../Makefile instead of this file to properly recompile
# all dependencies

COFFEE := ../../node_modules/.bin/coffee
BROWSERIFY := ../../node_modules/.bin/browserify

tmp_js := $(patsubst %.coffee,%.tmp.js,$(wildcard *.coffee))
browserify_js := $(patsubst %.coffee,%.browserify.js,$(wildcard *.coffee))

all: $(tmp_js) $(browserify_js)

.PHONY: depend
depend: $(tmp_js)
	ln -sf ../db.localstorage .
	make-commonjs-depend *tmp.js -o js.mk

-include js.mk

%.tmp.js: %.coffee
	coffee-inline-map $< -o $@

%.browserify.js: %.tmp.js
	$(BROWSERIFY) -d $< -o $@

.PHONY: clean
clean:
	rm -f $(tmp_js) $(browserify_js) db.localstorage js.mk
