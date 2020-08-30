USERNAME=tetov

DOCKER=docker

UPSTREAM_ORG=gramaziokohler
UPSTREAM_REPO=ros_docker
UPSTREAM_URL="https://github.com/$(UPSTREAM_ORG)/$(UPSTREAM_REPO).git"
UPSTREAM_HEAD_SHA=$(shell wget --header="Accept: application/vnd.github.VERSION.sha" -qO- http://api.github.com/repos/gramaziokohler/ros_docker/commits/master | head -c7)
UPSTREAM_RAW_URL="https://raw.githubusercontent.com/$(UPSTREAM_ORG)/$(UPSTREAM_REPO)/master"

.PHONY: all build

all: build

build: build-ros-base-git build-ros-abb-planner-git

build-ros-base-git:
	$(eval UPSTREAM_IMAGE:=ros-base)
	$(eval IMAGE:=$(UPSTREAM_IMAGE)-git)
	@echo 'Building $(IMAGE) image, last repo commit $(UPSTREAM_HEAD_SHA).'
	# @$(DOCKER) build --rm -t $(USERNAME)/$(IMAGE):$(UPSTREAM_HEAD_SHA) \
	#	-t $(USERNAME)/$(IMAGE):latest "$(UPSTREAM_URL)#:$(UPSTREAM_IMAGE)"
	@$(DOCKER) build --rm -t $(USERNAME)/$(IMAGE):$(UPSTREAM_HEAD_SHA) \
		-t $(USERNAME)/$(IMAGE):latest "https://github.com/tetov/ros_docker.git#patch-1:$(UPSTREAM_IMAGE)"
	@echo \\n****************************************************************\\n

build-ros-abb-planner-git:
	$(eval UPSTREAM_IMAGE:=ros-abb-planner)
	$(eval IMAGE:=$(UPSTREAM_IMAGE)-git)
	@echo 'Building $(IMAGE) image, last repo commit $(UPSTREAM_HEAD_SHA).'
	@wget -qO- $(UPSTREAM_RAW_URL)/$(UPSTREAM_IMAGE)/Dockerfile | \
		sed -r 's/FROM $(UPSTREAM_ORG)\/ros-base.*/FROM $(USERNAME)\/ros-base-git/g' | \
		$(DOCKER) build --rm -t $(USERNAME)/$(IMAGE):$(UPSTREAM_HEAD_SHA) \
		-t $(USERNAME)/$(IMAGE):latest -
	@echo \\n****************************************************************\\n

release: release-ros-base-git release-ros-abb-planner-git

release-ros-base-git:
	$(eval IMAGE:=ros-base-git)
	@echo 'Publishing $(IMAGE) image to dockerhub'
	@$(DOCKER) push $(USERNAME)/$(IMAGE)

release-ros-abb-combo-driver-planner:
	$(eval IMAGE:=ros-abb-combo-driver-planner)
	@echo 'Publishing $(IMAGE) image to dockerhub'
	@$(DOCKER) push $(USERNAME)/$(IMAGE)

