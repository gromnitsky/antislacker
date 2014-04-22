where_am_i = $(lastword $(MAKEFILE_LIST))
MK_LOCATION := $(realpath $(call where_am_i))
MK_DIR := $(dir $(MK_LOCATION))

include $(MK_DIR)/../mk/debug.mk

JSON2LOCALSTORAGE := $(MK_DIR)/../test/json2localstorage
BROWSERIFY := ../node_modules/.bin/browserify
COFFEE := ../node_modules/.bin/coffee

out := ../lib
html := $(wildcard *.html)
out_html := $(patsubst %.html,$(out)/%.html,$(html))
out_localstorage := $(patsubst %.json,$(out)/%.localstorage,$(wildcard *.json))

# compiled & bundled this will go to $(out)
coffee := background.coffee content_script.coffee

out_js := $(patsubst %.coffee,$(out)/%.js,$(coffee))
temp_js := $(patsubst %.coffee,%.js,$(wildcard *.coffee))

all: compile

#$(out)/background.js: foo.js

%.js: %.coffee
	$(COFFEE) -c $<

.PHONY: depend
depend: $(temp_js)
	make-commonjs-depend *js -o js.mk

-include js.mk

$(out)/%.js: %.js
	@mkdir -p `dirname $@`
	$(BROWSERIFY) $< -o $@

$(out)/%.html: %.html
	cp $< $@

$(out)/%.localstorage: %.json
	$(JSON2LOCALSTORAGE) $< $@

.PHONY: compile
compile: $(temp_js) $(out_js) $(out_html) $(out_localstorage)

.PHONY: clean
clean:
	rm -f $(out_js) $(temp_js) $(out_html) $(out_localstorage) js.mk
