# Put GNAT Pro .tar.gz into this directory to be installed
# otherwise it will install GNAT from Ubuntu.

FROM ubuntu:22.04

RUN apt-get update -y

RUN apt-get upgrade -y
RUN apt-get install -y  make \
                        gnat \
                        gcc \
                        g++ \
                        git \
                        gdb \
                        gprbuild \
                        libc6-dev \
                        python3

RUN rm -rf /var/lib/apt/lists/*
RUN apt-get purge --auto-remove
RUN apt-get clean
