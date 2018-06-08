FROM node:9

# Install Python.
RUN \
  apt-get update && \
    apt-get install -y python python-dev python-pip python-virtualenv && \
    rm -rf /var/lib/apt/lists/*

RUN pip install mkdocs pygments pymdown-extensions tornado

USER node

RUN mkdir /home/node/app

WORKDIR /home/node/app

EXPOSE 8000
