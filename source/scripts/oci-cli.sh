#!/bin/bash
# oci-cli.sh

# スクリプトをエラーで停止させる
set -e

# パッケージのアップデート
sudo -u builder -- paru -S --noconfirm python-terminaltables3
mv /var/cache/pacman/pkg/*.pkg.tar.zst ${PACKAGE_PATH}/dist