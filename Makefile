include mk/debug.mk

M4 := m4
JSON := json
MOCHA := node_modules/.bin/mocha

METADATA := package.json
PKG := $(shell $(JSON) -a -d- name version < $(METADATA))
PKG_FILES := $(shell $(JSON) files < $(METADATA) | $(JSON) -a)

OPTS :=

.PHONY: clobber clean manifest_clean compile_clean test_clean compile depend

all: test

include mk/chrome.mk
include mk/bower.mk

test_compile:
	$(MAKE) -C test

test: compile test_compile
	$(MOCHA) --compilers coffee:coffee-script/register \
		-u tdd test/test_*.coffee $(OPTS)

compile: node_modules bower_components manifest.json bower.copy
	$(MAKE) -C src compile

depend:
	$(MAKE) -C src depend
	$(MAKE) -C test/browser depend

bower_components: bower.json
	bower install
	touch $@

compile_clean:
	$(MAKE) -C src clean

node_modules: package.json
	npm install
	touch $@

manifest.json: manifest.m4 $(METADATA)
	$(M4) $< > $@

manifest_clean:
	rm -f manifest.json

test_clean:
	$(MAKE) -C test clean

clean: manifest_clean compile_clean chrome_clean test_clean bower.clean
	[ -r lib ] && rmdir lib; :

clobber: clean
	rm -rf node_modules bower_components

.PHONY: http
http:
	python -m SimpleHTTPServer || :
