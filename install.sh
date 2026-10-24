#!/bin/bash
set -euo pipefail

mise install --yes
mise exec -- ya pkg install
mise exec -- nvim --headless "+Lazy! restore" +qa
NVIM_APPNAME=nvim-lite mise exec -- nvim --headless +qa
