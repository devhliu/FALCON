FROM python:3.8.12-slim-bullseye
WORKDIR /app

# timezone
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# debian
RUN sed -i 's#http://deb.debian.org/debian#http://mirrors.ustc.edu.cn/debian#' /etc/apt/sources.list

# pip
RUN python -m pip install --upgrade pip -i https://pypi.tuna.tsinghua.edu.cn/simple \
    && pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple

# Installing the necessary libraries
RUN apt-get update \
    && apt-get install -y sudo unzip build-essential curl cmake git libexpat1-dev libhdf5-dev \
                          libjpeg-dev libpython3-dev libtiff5-dev ninja-build wget vim pigz zlib1g-dev

RUN pip install scikit-build cmake

WORKDIR /
RUN git clone https://github.com/QIMP-Team/FALCON.git
RUN git checkout kube
WORKDIR /FALCON
RUN . ./falcon_installer.sh
RUN . /root/.bashrc
