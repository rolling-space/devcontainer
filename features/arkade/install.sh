#!/bin/sh
#-------------------------------------------------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See https://github.com/devcontainers/features/blob/main/LICENSE for license information.
#-------------------------------------------------------------------------------------------------------------------------
#
# Docs: https://github.com/devcontainers/features/tree/main/src/arkade
# Maintainer: The Dev Container spec maintainers

set -e

ARKADE_VERSION="latest"
INSTALL_DIR="/usr/local/bin"

if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi

# Install dependencies
if [ -x "$(command -v curl)" ]; then
    echo "curl is already installed."
else
    echo "Installing curl..."
    apt-get update && apt-get install -y curl
fi

# Install Arkade CLI
echo "Installing Arkade CLI..."
curl -sSL https://get.arkade.dev | sh

echo "Arkade CLI installed successfully."