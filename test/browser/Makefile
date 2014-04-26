COFFEE := ../../node_modules/.bin/coffee
BROWSERIFY := ../../node_modules/.bin/browserify

tmp_js := $(patsubst %.coffee,%.tmp.js,$(wildcard *.coffee))
browserify_js := $(patsubst %.coffee,%.browserify.js,$(wildcard *.coffee))

all: $(browserify_js)

%.tmp.js: %.coffee
	$(COFFEE) -cp $< > $@

%.browserify.js: %.tmp.js
	$(BROWSERIFY) $< -o $@

.PHONY: clean
clean:
	rm -f $(tmp_js) $(browserify_js)
