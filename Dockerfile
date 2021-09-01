## BASE
FROM ubuntu:20.04
WORKDIR /root
RUN apt update -y && \
    apt install -y vim
COPY ./vimrc $HOME/.vimrc

# ROS LOCALES 
RUN apt update -y && \
    apt install -y locales 
RUN locale-gen en_US en_US.UTF-8 && \
    update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
ENV LANG=en_US.UTF-8

# ROS PACKAGES SOURCE
RUN apt install -y curl gnupg lsb-release
RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key  -o /usr/share/keyrings/ros-archive-keyring.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null

## ROS PACKAGES
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Indian/Maldives
RUN apt update && apt install -y \
                      build-essential \
                      gcc \
                      cmake \
                      git \
                      pip \
                      python3-colcon-common-extensions \
                      python3-flake8 \
                      python3-pip \
                      python3-pytest-cov \
                      python3-rosdep \
                      python3-setuptools \
                      python3-vcstool \
                      wget
# install some pip packages needed for testing
RUN python3 -m pip install -U \
                      flake8-blind-except \
                      flake8-builtins \
                      flake8-class-newline \
                      flake8-comprehensions \
                      flake8-deprecated \
                      flake8-docstrings \
                      flake8-import-order \
                      flake8-quotes \
                      pytest-repeat \
                      pytest-rerunfailures \
                      pytest \
                      setuptools

# ROS WORKSPACE SETUP
RUN mkdir -p ~/ros2_galactic/src && \
    cd ~/ros2_galactic && \
    wget https://raw.githubusercontent.com/ros2/ros2/galactic/ros2.repos && \
    vcs import src < ros2.repos
RUN cd ~/ros2_galactic && \
    rosdep init && \
    rosdep update && \
    rosdep install --from-paths src --ignore-src --rosdistro galactic -y --skip-keys "console_bridge fastcdr fastrtps rti-connext-dds-5.3.1 urdfdom_headers"

MAINTAINER somidi saikrn112@gmail.com
