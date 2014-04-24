# Copy staff from bower dir

lib/angular.js: bower_components/angular/angular.js
	@mkdir -p lib
	cp $< $@

.PHONY: bower.copy
bower.copy: lib/angular.js

.PHONY: bower.clean
bower.clean:
	rm -f lib/angular.js
