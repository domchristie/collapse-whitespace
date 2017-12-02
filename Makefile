browserify := ./node_modules/.bin/browserify
uglify := ./node_modules/.bin/uglifyjs
standard := ./node_modules/.bin/standard

SRC = $(wildcard src/*.js)
LIB = $(SRC:src/%.js=lib/%.js)

whitespace.min.js: $(LIB)
	$(browserify) lib/whitespace.cjs.js -s collapse | $(uglify) -m > $@

lib/%.js: src/%.js
	@mkdir -p $(@D)
	@cp $< lib/whitespace.cjs.js
	@echo "\nmodule.exports = collapseWhitespace" >> lib/whitespace.cjs.js
	@cp $< lib/whitespace.es.js
	@echo "\nexport default collapseWhitespace" >> lib/whitespace.es.js

lint:
	$(standard) $(SRC)

test: whitespace.min.js
	@echo "Open test.html in your browser to run tests."

publish: whitespace.min.js $(LIB)
	npm publish

.PHONY: lint test publish
