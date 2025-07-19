#!/bin/bash
# oci-cli.sh

# スクリプトをエラーで停止させる
set -e

# パッケージのアップデート
sudo -u builder -- paru -S --noconfirm python-terminaltables3