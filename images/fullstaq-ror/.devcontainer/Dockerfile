#FROM quay.io/evl.ms/fullstaq-ruby:3.4.3-jemalloc-bookworm
FROM ghcr.io/moritzheiber/ruby-jemalloc:3.4.3-slim@sha256:0e1d58482df398726c9c12510fee459e3a6034b3bccf550c9d27ec756e436fdc

RUN apt-get update && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get dist-upgrade -y && \
    apt-get install --assume-yes -q --no-install-recommends \
    ncdu \
    # Remove imagemagick due to https://security-tracker.debian.org/tracker/CVE-2019-10131
    && apt-get purge -y imagemagick imagemagick-6-common \
        && apt-get autoremove --assume-yes \
        && rm -rf /var/lib/apt/lists \
        && rm -fr /var/cache/apt

ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

ENV LD_PRELOAD="libjemalloc.so.2" \
    MALLOC_CONF="dirty_decay_ms:1000,narenas:2,background_thread:true,stats_print:false" \
    RUBY_YJIT_ENABLE="1" \
    PATH=/opt/ruby/bin:$PATH

USER coder
