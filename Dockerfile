FROM ros:noetic-ros-base

# install ros package
RUN apt update && apt install -y \
      ros-${ROS_DISTRO}-moveit \
      ros-${ROS_DISTRO}-xacro \
      ros-${ROS_DISTRO}-joint-state-publisher \
      ros-${ROS_DISTRO}-robot-state-publisher \
      ros-${ROS_DISTRO}-rviz && \
    rm -rf /var/lib/apt/lists/*

# Install GIT
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y git vim python-is-python3

ENV PROJECT_NAME=unity_demo
ENV PROJECT_DIR=/opt/$PROJECT_NAME
RUN mkdir $PROJECT_DIR

# Setup ROS/Unity libraries
ENV LIB_NAME=unity_lib
RUN mkdir $PROJECT_DIR/$LIB_NAME
RUN mkdir $PROJECT_DIR/$LIB_NAME/src
WORKDIR $PROJECT_DIR/$LIB_NAME/src

RUN git clone https://github.com/Unity-Technologies/ROS-TCP-Endpoint.git
RUN git clone https://github.com/szandara/unity_moveit_manager.git
RUN bash -c "source /opt/ros/noetic/setup.bash && cd $PROJECT_DIR/$LIB_NAME && catkin_make"