# syntax=docker/dockerfile:experimental
# Build:
#  docker build --rm -f Dockerfile -t tetov/ros-abb-combo-driver-planner --ssh default .
#
# Usage:
#  docker pull tetov/ros-abb-combo-driver-planner
FROM tetov/ros-base-git:latest

LABEL maintainer="Anton Tetov <anton@tetov.se>"

# Install packages
RUN apt-get update && apt-get install -y \
    # Basic utilities
    iputils-ping git openssh-client \
    # ROS bridge server and related packages
    ros-${ROS_DISTRO}-rosbridge-server \
    ros-${ROS_DISTRO}-tf2-web-republisher \
    # ROS MoveIt
    ros-${ROS_DISTRO}-moveit \
    --no-install-recommends \
    # Clear apt-cache to reduce image size
    && rm -rf /var/lib/apt/lists/*

# Build number
ENV RRC_BUILD=1

# Clone private repo compas_rrc_ros
RUN --mount=type=ssh mkdir -p -m 0600 ~/.ssh \
    && ssh-keyscan github.com >> ~/.ssh/known_hosts \
    && git clone git@github.com:gramaziokohler/compas_rrc_ros.git

# Add robot packages to local catkin workspace
RUN source /opt/ros/${ROS_DISTRO}/setup.bash \
    # Update apt-get because its cache is always cleared after installs to keep image size down
    && apt-get update \
    # ABB packages
    && git clone -b ${ROS_DISTRO}-devel https://github.com/ros-industrial/abb.git \
    && git clone -b ${ROS_DISTRO}-devel https://github.com/ros-industrial/abb_experimental.git \
    && git clone https://github.com/gramaziokohler/abb_irb4600_40_255.git \
    && git clone https://github.com/gramaziokohler/abb_irb4600_40_255_moveit_config.git \
    # Install dependencies
    && cd $CATKIN_WS \
    && rosdep install -y --from-paths . --ignore-src --rosdistro ${ROS_DISTRO} \
    # Build catkin workspace
    && catkin_make
