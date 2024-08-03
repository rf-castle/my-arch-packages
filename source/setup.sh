#!/bin/bash
# setup.sh
# ルートで実行しておきたい処理を記述する

# スクリプトをエラーで停止させる
set -e

# パッケージのアップデート
pacman -Syu --noconfirm
pacman -S --noconfirm --needed base-devel git

# ビルド用ユーザーの作成
useradd -m -G wheel -s /bin/bash builder
echo "builder ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
chown -R builder .

