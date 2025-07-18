#!/bin/bash
# oci-cli.sh

# スクリプトをエラーで停止させる
set -e

# パッケージのアップデート
pacman -S --noconfirm python-terminaltables3