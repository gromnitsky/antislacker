where_am_i = $(lastword $(MAKEFILE_LIST))
MK_LOCATION := $(realpath $(call where_am_i))
MK_DIR := $(dir $(MK_LOCATION))

include $(MK_DIR)/../mk/debug.mk

localstorage := $(patsubst %.json,%.localstorage,$(wildcard *.json))

all: $(localstorage) browser

.PHONY: browser
browser:
	$(MAKE) -C browser


%.localstorage: %.json
	./json2localstorage $< $@

.PHONY: clean
clean:
	rm -f $(localstorage)
	$(MAKE) -C browser clean
