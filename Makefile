include mk/debug.mk

M4 := m4
JSON := json
MOCHA := node_modules/.bin/mocha

METADATA := package.json
PKG := $(shell $(JSON) -a -d- name version < $(METADATA))
PKG_FILES := $(shell $(JSON) files < $(METADATA) | $(JSON) -a)

OPTS :=

.PHONY: clobber clean manifest_clean compile_clean

all: test

test_compile:
	$(MAKE) -C test

test: compile test_compile
	$(MOCHA) --compilers coffee:coffee-script/register \
		-u tdd test/test_*.coffee $(OPTS)

compile: node_modules manifest.json
	$(MAKE) -C src compile

include mk/chrome.mk

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

clean: manifest_clean compile_clean chrome_clean test_clean
	[ -r lib ] && rmdir lib; :

clobber: clean
	rm -rf node_modules
