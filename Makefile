USERNAME=tetov

DOCKER=docker

VERSION=v1.0.0

.PHONY: all build

all: build

build: build-ros-melodic-abb-planner

build-ros-melodic-abb-planner:
	$(eval IMAGE:=ros-melodic-abb-planner)
	@echo 'Building $(IMAGE) image.'
	@cd $(IMAGE) && $(DOCKER) build --rm \
		-t $(USERNAME)/$(IMAGE):$(VERSION) \
		-t $(USERNAME)/$(IMAGE):latest .

release: build-ros-melodic-abb-planner

release-ros-melodic-abb-planner:
	$(eval IMAGE:=ros-melodic-abb-planner)
	@echo 'Publishing $(IMAGE) image to dockerhub.'
	@$(DOCKER) push $(USERNAME)/$(IMAGE)

