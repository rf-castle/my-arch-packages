#!/bin/bash
# oci-cli.sh

# スクリプトをエラーで停止させる
set -e

# パッケージのアップデート
sudo -u builder -- paru -S --noconfirm python-terminaltables3
mkdir -p ${PACKAGE_PATH}/dist
mv /var/cache/pacman/pkg/*.pkg.tar.zst ${PACKAGE_PATH}/dist