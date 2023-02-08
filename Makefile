.PHONY: image citest test release

IMAGE_NAME ?= codeclimate/codeclimate-coffeelint
RELEASE_REGISTRY ?= codeclimate
RELEASE_TAG ?= latest

image:
	docker build --tag $(IMAGE_NAME) .

citest:
	docker run --rm $(IMAGE_NAME) sh -c "cd /usr/src/app && bundle exec rake"

test: image citest

release:
	docker tag $(IMAGE_NAME) $(RELEASE_REGISTRY)/codeclimate-coffeelint:$(RELEASE_TAG)
	docker push $(RELEASE_REGISTRY)/codeclimate-coffeelint:$(RELEASE_TAG)
