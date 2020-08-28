USERNAME=tetov
VERSION=$(shell cat VERSION)

DOCKER=docker

ROS_BASE_GIT_BUILD_CTX="https://github.com/gramaziokohler/ros_docker.git\#:ros-base"

.PHONY: all build

all: build

build: build-ros-base-git  build-ros-abb-combo-driver-planner

build-ros-base-git:
	$(eval IMAGE:=ros-base-git)
	@echo 'Building $(IMAGE) image, version $(VERSION)'
	@$(DOCKER) build --rm -t $(USERNAME)/$(IMAGE):$(VERSION) \
		-t $(USERNAME)/$(IMAGE):latest $(ROS_BASE_GIT_BUILD_CTX)
	@echo \\n****************************************************************\\n

build-ros-abb-combo-driver-planner:
	$(eval IMAGE:=ros-abb-combo-driver-planner)
	@echo 'Building $(IMAGE) image, version $(VERSION)'
	@cd $(IMAGE) ; \
		DOCKER_BUILDKIT=1 $(DOCKER) build --rm -t $(USERNAME)/$(IMAGE):$(VERSION) \
		-t $(USERNAME)/$(IMAGE):latest --ssh default .
	@echo \\n****************************************************************\\n

release: release-ros-base-git release-ros-abb-combo-driver-planner

release-ros-base-git:
	$(eval IMAGE:=ros-base-git)
	@echo 'Publishing $(IMAGE) image to dockerhub'
	@$(DOCKER) push $(USERNAME)/$(IMAGE)

release-ros-abb-combo-driver-planner:
	$(eval IMAGE:=ros-abb-combo-driver-planner)
	@echo 'Publishing $(IMAGE) image to dockerhub'
	@$(DOCKER) push $(USERNAME)/$(IMAGE)

