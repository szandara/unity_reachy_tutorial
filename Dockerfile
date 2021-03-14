FROM ros:noetic

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
    apt-get install -y git

ENV PROJECT_NAME=cleanr
ENV PROJECT_DIR=/opt/$PROJECT_NAME
RUN mkdir $PROJECT_DIR

# Setup reachy
RUN mkdir $PROJECT_DIR/reachy/
RUN mkdir $PROJECT_DIR/reachy/src
WORKDIR $PROJECT_DIR/reachy/src

RUN git clone https://github.com/pollen-robotics/reachy_moveit_config --branch release-1.0.0
RUN git clone https://github.com/pollen-robotics/reachy_description
RUN cd reachy_description && git checkout ce171a0aac7f665e88e99395690e773adb096f67
RUN bash -c "source /opt/ros/noetic/setup.bash && cd $PROJECT_DIR/reachy && catkin_make"

# Setup ROS/Unity
RUN mkdir $PROJECT_DIR/simulation/
RUN mkdir $PROJECT_DIR/simulation/src
WORKDIR $PROJECT_DIR/simulation/src

RUN git clone https://github.com/Unity-Technologies/ROS-TCP-Endpoint.git
RUN bash -c "source /opt/ros/noetic/setup.bash && cd $PROJECT_DIR/simulation && catkin_make"

RUN cd $PROJECT_DIR
RUN apt install -y python-is-python3

#WORKDIR $PROJECT_DIR/

#RUN git clone https://github.com/szandara/unity_moveit_manager.git
#RUN bash -c "source $PROJECT_DIR/simulation/devel/setup.bash && cd $PROJECT_DIR/unity_moveit_manager && catkin_make"