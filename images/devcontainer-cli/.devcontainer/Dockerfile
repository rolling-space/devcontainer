FROM mcr.microsoft.com/devcontainers/javascript-node:1-20-bookworm

RUN apt-get update && apt-get install -y shellcheck git

ENTRYPOINT [ "/usr/local/share/docker-init.sh" ]

SHELL [ "/bin/bash", "-o", "pipeline", "-c" ]
