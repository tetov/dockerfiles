# Build:
#  docker build --rm -f Dockerfile -t tetov/ros-melodic-abb-planner .
#
# Usage:
#  docker pull tetov/ros-melodic-abb-planner

FROM ros:melodic
LABEL maintainer "Anton Tetov <anton@tetov.se>"

SHELL ["/bin/bash","-c"]

# Install packages
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list' \
    && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654 \
    && apt-get update \
    && apt-get install -y \
    # Basic utilities
    iputils-ping \
    # ROS bridge server and related packages
    ros-${ROS_DISTRO}-rosbridge-server \
    ros-${ROS_DISTRO}-tf2-web-republisher \
    --no-install-recommends

# Create local catkin workspace
ENV CATKIN_WS=/root/catkin_ws
RUN mkdir -p $CATKIN_WS/src
WORKDIR $CATKIN_WS/src

# Initialize local catkin workspace
RUN source /opt/ros/${ROS_DISTRO}/setup.bash \
    # Update apt-get because its cache is always cleared after installs to keep image size down
    && apt-get update \
    # Install dependencies
    && cd $CATKIN_WS \
    && rosdep install -y --from-paths . --ignore-src --rosdistro ${ROS_DISTRO} \
    # Build catkin workspace
    && catkin_make

# Install packages
RUN apt-get update && apt-get install -y \
    # ROS MoveIt
    ros-${ROS_DISTRO}-moveit \
    --no-install-recommends 

# Add robot packages to local catkin workspace
RUN source /opt/ros/${ROS_DISTRO}/setup.bash \
    # Update apt-get because its cache is always cleared after installs to keep image size down
    && apt-get update \
    # ROS File Server
    && git clone https://github.com/gramaziokohler/ros_file_server.git \
    # ABB packages
    && git clone -b kinetic-devel https://github.com/ros-industrial/abb.git \
    && git clone -b kinetic-devel https://github.com/ros-industrial/abb_experimental.git \
    && git clone https://github.com/gramaziokohler/abb_irb4600_40_255.git \
    && git clone https://github.com/gramaziokohler/abb_irb4600_40_255_moveit_config.git \
    # Install dependencies
    && cd $CATKIN_WS \
    && rosdep install -y --from-paths . --ignore-src --rosdistro ${ROS_DISTRO} \
    # Build catkin workspace
    && catkin_make \
    # Clear apt-cache to reduce image size
    && rm -rf /var/lib/apt/lists/*

COPY ./ros_catkin_entrypoint.sh /
RUN chmod +x /ros_catkin_entrypoint.sh \
    # Always source ros_entrypoint.sh when launching bash (e.g. when attaching to container)
    && echo "source /ros_catkin_entrypoint.sh" >> /root/.bashrc

ENTRYPOINT ["/ros_catkin_entrypoint.sh"]
CMD ["bash"]
