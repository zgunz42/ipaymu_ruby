.PHONY: console build

console: build
	docker run -it -v="$(PWD):/ipaymu-ruby" --net="host" ipaymu-ruby /bin/bash -l -c "bundle install;bash -l"

build:
	docker build -t ipaymu-ruby .

lint: build
	docker run -i -v="$(PWD):/ipaymu-ruby" --net="host" ipaymu-ruby /bin/bash -l -c "bundle install;rake lint"