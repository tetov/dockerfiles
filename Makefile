USERNAME=tetov

DOCKER=docker

UPSTREAM_ORG=gramaziokohler
UPSTREAM_REPO=ros_docker
UPSTREAM_URL="https://github.com/$(UPSTREAM_ORG)/$(UPSTREAM_REPO).git"
UPSTREAM_HEAD_SHA=$(shell wget --header="Accept: application/vnd.github.VERSION.sha" -qO- http://api.github.com/repos/gramaziokohler/ros_docker/commits/master | head -c7)
UPSTREAM_RAW_URL="https://raw.githubusercontent.com/$(UPSTREAM_ORG)/$(UPSTREAM_REPO)/master"

.PHONY: all build

all: build

build: build-ros-base-git build-ros-abb-planner-git build-ros-melodic-abb-planner

build-ros-base-git:
	$(eval UPSTREAM_IMAGE:=ros-base)
	$(eval IMAGE:=$(UPSTREAM_IMAGE)-git)
	@echo 'Building $(IMAGE) image, last repo commit $(UPSTREAM_HEAD_SHA).'
	@$(DOCKER) build --rm \
		-t $(USERNAME)/$(IMAGE):$(UPSTREAM_HEAD_SHA) \
		-t $(USERNAME)/$(IMAGE):latest \
		"$(UPSTREAM_URL)#:$(UPSTREAM_IMAGE)"
	@echo \\n****************************************************************\\n

build-ros-abb-planner-git:
	$(eval UPSTREAM_IMAGE:=ros-abb-planner)
	$(eval IMAGE:=$(UPSTREAM_IMAGE)-git)
	@echo 'Building $(IMAGE) image, last repo commit $(UPSTREAM_HEAD_SHA).'
	@wget -qO- $(UPSTREAM_RAW_URL)/$(UPSTREAM_IMAGE)/Dockerfile | \
		sed -r 's/FROM $(UPSTREAM_ORG)\/ros-base.*/FROM $(USERNAME)\/ros-base-git/g' | \
		$(DOCKER) build --rm \
		-t $(USERNAME)/$(IMAGE):$(UPSTREAM_HEAD_SHA) \
		-t $(USERNAME)/$(IMAGE):latest -
	@echo \\n****************************************************************\\n

build-ros-melodic-abb-planner:
	$(eval IMAGE:=ros-melodic-abb-planner)
	$(eval VERSION:=v1.0.0)
	@echo 'Building $(IMAGE) image.'
	@cd $(IMAGE) && $(DOCKER) build --rm \
		-t $(USERNAME)/$(IMAGE):$(VERSION) \
		-t $(USERNAME)/$(IMAGE):latest .

release: release-ros-base-git release-ros-abb-planner-git

release-ros-base-git:
	$(eval IMAGE:=ros-base-git)
	@echo 'Publishing $(IMAGE) image to dockerhub'
	@$(DOCKER) push $(USERNAME)/$(IMAGE)

release-ros-abb-planner-git:
	$(eval IMAGE:=ros-abb-planner-git)
	@echo 'Publishing $(IMAGE) image to dockerhub'
	@$(DOCKER) push $(USERNAME)/$(IMAGE)

release-ros-melodic-abb-planner:
	$(eval IMAGE:=ros-melodic-abb-planner)
	@echo 'Publishing $(IMAGE) image to dockerhub.'
	@$(DOCKER) push $(USERNAME)/$(IMAGE)

