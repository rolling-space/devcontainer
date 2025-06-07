ARG SYSTEM_RUBY_VERSION=3.4.3
ARG SYSTEM_RUBY_VARIANT=jemalloc
ARG DEBIAN_EDITION=bookworm
ARG SYSTEM_PLATFORM=linux/arm64

FROM --platform=$SYSTEM_PLATFORM quay.io/evl.ms/fullstaq-ruby:${SYSTEM_RUBY_VERSION}-${SYSTEM_RUBY_VARIANT}-${DEBIAN_EDITION}

ARG USERNAME=runner

ARG RUBY_VERSION=3.4.4
ARG RUBY_VARIANT=jemalloc
ARG DEBIAN_VERSION=12
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    # Remove imagemagick due to https://security-tracker.debian.org/tracker/CVE-2019-10131
    && apt-get purge -y imagemagick imagemagick-6-common \
    && curl -SLf https://raw.githubusercontent.com/fullstaq-labs/fullstaq-ruby-server-edition/main/fullstaq-ruby.asc | apt-key add - \
    && echo "deb https://apt.fullstaqruby.org debian-${DEBIAN_VERSION} main" > /etc/apt/sources.list.d/fullstaq-ruby.list \
    && apt-get update -q \
    && apt-get install --assume-yes -q --no-install-recommends fullstaq-ruby-common fullstaq-ruby-${RUBY_VERSION}-${RUBY_VARIANT} unzip sudo \
    && echo 'eval "$(rbenv init - )"' >> /etc/bash.bashrc \
    && apt-get autoremove --assume-yes \
    && rm -rf /var/lib/apt/lists \
    && rm -fr /var/cache/apt \
    && cp /etc/apt/sources.list.d/fullstaq-ruby.list ${HOME} \
    && rm /etc/apt/sources.list.d/fullstaq-ruby.list

    
RUN groupadd --gid 1000 node \
    && groupadd -g 4242 runtime \
    && useradd --uid 1000 --gid node --shell /bin/bash --create-home node \
    && usermod -aG runtime,0 node \
    && chgrp -R 0 /home /etc/passwd /etc/group /etc/shadow \
    && chmod -R g=u /home /etc/passwd /etc/group /etc/shadow


ENV HOME /home/node
RUN echo "node ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/node \
    && chmod 0440 /etc/sudoers.d/node

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

RUN curl -fsSL https://fnm.vercel.app/install | bash -s -- --install-dir "/usr/local/bin" \
        && echo 'eval "$(fnm env --use-on-cd --shell bash)"' >> /root/.bashrc \
        && echo 'eval "$(fnm env --use-on-cd --shell bash)"' >> /home/node/.bashrc

ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

ENV MALLOC_CONF="dirty_decay_ms:1000,narenas:2,background_thread:true,stats_print:false" \
    RUBY_YJIT_ENABLE="1"

USER 1000
