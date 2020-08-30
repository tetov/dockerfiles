# repo with dockerfiles and convenient makefile

At the moment no dockerfiles though `¯\_(ツ)_/¯`.

Makefile adapted from [gramaziokohler/ros_docker](https://github.com/gramaziokohler/ros_docker/blob/master/Makefile).

## ros-base-git

Based on [gramaziokohler/ros-base](https://hub.docker.com/r/gramaziokohler/ros-base)

Docker image built from last commit to [gramaziokohler/ros_docker](https://github.com/gramaziokohler/ros_docker).

```bash
docker pull tetov/ros-base-git
```

## ros-abb-planner-git

Based on [gramaziokohler/ros-abb-planner](https://hub.docker.com/r/gramaziokohler/ros-abb-planner)

Docker image built from last commit to [gramaziokohler/ros_docker](https://github.com/gramaziokohler/ros_docker), using ros-base-git as the base image.

### Usage

```bash
docker pull tetov/ros-abb-planner-git
```
