FROM debian:stable-slim
WORKDIR /config/

# curl and ca-certificates are needed for volta installation
RUN apt-get update \
  && apt-get install -y \
  curl \
  procps \
  ca-certificates \
  --no-install-recommends \
  && rm -rf /var/lib/apt/lists/*

# bash will load volta() function via .bashrc 
# using $VOLTA_HOME/load.sh
SHELL ["/bin/bash", "-c"]


# since we're starting non-interactive shell, 
# we wil need to tell bash to load .bashrc manually
ENV BASH_ENV ~/.bashrc
# needed by volta() function
ENV VOLTA_HOME /root/.volta
# make sure packages managed by volta will be in PATH
ENV PATH $VOLTA_HOME/bin:$PATH

# install volta
RUN curl https://get.volta.sh | bash
RUN volta install node

# test whether global installation of packages works
WORKDIR /app/


CMD [ "yarn", "install" ]

EXPOSE 3000