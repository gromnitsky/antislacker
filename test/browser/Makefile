# WARNING: run ../../Makefile instead of this file to properly recompile
# all dependencies

include ../../mk/debug.mk

COFFEE := ../../node_modules/.bin/coffee-inline-map
BROWSERIFY := ../../node_modules/.bin/browserify

tmp_js := $(patsubst %.coffee,%.js,$(wildcard test_*.coffee))
browserify_js := $(addsuffix .browserify.js,$(basename $(tmp_js)))

all: $(tmp_js) $(browserify_js)

.PHONY: depend
depend: $(tmp_js)
	ln -sf ../db.localstorage .
	make-commonjs-depend $(tmp_js) -o js.mk

-include js.mk

%.js: %.coffee
	$(COFFEE) $< -o $@

%.browserify.js: %.js
	$(BROWSERIFY) -d $< -o $@

.PHONY: clean
clean:
	rm -f $(tmp_js) $(browserify_js) db.localstorage js.mk
