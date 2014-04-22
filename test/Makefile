localstorage := $(patsubst %.json,%.localstorage,$(wildcard *.json))

all: $(localstorage)

%.localstorage: %.json
	./json2localstorage $< $@

.PHONY: clean
clean:
	rm -f $(localstorage)

# Debug. Use 'gmake p-obj' to print $(obj) variable.
p-%:
	@echo $* = $($*)
	@echo $*\'s origin is $(origin $*)
