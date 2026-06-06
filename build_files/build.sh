#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/43/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
dnf5 install -y tmux @cosmic-desktop @cosmic-desktop-apps

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#### Flatpak Installation

mkdir -p /etc/ublue-os

# Read from your repository layout folder structure and pipe it to the OS tracking list
if [ -f /tmp/repo_files/flatpaks ]; then
    cp /tmp/repo_files/flatpaks /etc/ublue-os/system-flatpaks.list
fi

#### System Configuration

# Enforce system-wide fallback symlink for terminal shortcuts to utilize COSMIC terminal emulator natively
ln -sf /usr/bin/cosmic-terminal /usr/bin/x-terminal-emulator

#### Example for enabling a System Unit File

systemctl enable podman.socket


# Ensure docker group exists for devcontainers

if ! grep -q "^docker:" /etc/group; then
    groupadd docker || true
fi
