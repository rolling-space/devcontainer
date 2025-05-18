FROM ghcr.io/rolling-space/devcontainer/images/ruby:3.4.3

USER 0
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    # Remove imagemagick due to https://security-tracker.debian.org/tracker/CVE-2019-10131
    && apt-get update -y && apt-get -y install --no-install-recommends ncdu && \
    rm -rf /var/lib/apt/lists/*    

ENV LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8

RUN mkdir -p /bench && \
    chown -R 10001:10001 /bench

WORKDIR /bench

COPY --chown="10001:10001" ruby-config.sh .

USER 10001

