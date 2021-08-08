# repo with dockerfiles and convenient makefile

Makefile adapted from
[gramaziokohler/ros_docker](https://github.com/gramaziokohler/ros_docker/blob/master/Makefile).

## ros-melodic-abb-planner-git

Based on [gramaziokohler/ros-abb-planner](https://hub.docker.com/r/gramaziokohler/ros-abb-planner)
but uses [ros:melodic](https://hub.docker.com/layers/ros/library/ros/melodic/images/sha256-f9ab26ad9caf7c6025ff2669c4a4413746b68ea9ed05b3641829ccb515771e8b?context=explore)
instead of [ros:kinetic](https://hub.docker.com/layers/ros/library/ros/kinetic/images/sha256-6aa9871749c213a24f429a77db3f062a7de532602524cd47caf3751794ffb053?context=explore)
as base.

### Usage

```bash
docker pull tetov/ros-melodic-abb-planner-git
```
