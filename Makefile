.PHONY: image citest test

IMAGE_NAME ?= codeclimate/codeclimate-coffeelint

image:
	docker build --tag $(IMAGE_NAME) .

citest:
	docker run --rm $(IMAGE_NAME) bundle exec rake

test: image citest
