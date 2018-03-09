VERSION ?= latest
REPO ?= gumby
APP ?= kapp

.PHONY: build
build:
	GOOS=linux go build -o $(APP) cmd/dbtest/main.go
	docker build --build-arg APP=$(APP) -t $(APP):$(VERSION) .
	rm $(APP)

.PHONY: publish
publish: build tag
	@echo 'publish $(VERSION) to $(REPO)'
	docker push $(REPO)/$(APP):$(VERSION)

.PHONY: tag
tag:
	@echo 'tagging $(APP):$(VERSION) to $(REPO)'
	docker tag $(APP) $(REPO)/$(APP):$(VERSION)