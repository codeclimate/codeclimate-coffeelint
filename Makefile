.PHONY: image test

IMAGE_NAME ?= codeclimate/codeclimate-coffeelint

image:
	docker build --tag $(IMAGE_NAME) .

test: image
	docker run --rm $(IMAGE_NAME) sh -c "cd /usr/src/app && npm run test"
