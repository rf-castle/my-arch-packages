#!/bin/bash
# setup.sh

# スクリプトをエラーで停止させる
set -e

# パッケージのアップデート
pacman -Syu --noconfirm
pacman -S --noconfirm --needed base-devel git

# ビルド用ユーザーの作成
useradd -m -G wheel -s /bin/bash builder
echo "builder ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# paruのインストール(依存パッケージを持ってきながらビルドするため用)
git clone https://aur.archlinux.org/paru.git
chown -R builder:builder paru
pushd paru
sudo -u builder -- makepkg -isr --noconfirm
sudo -u builder -- mv paru-*.pkg.tar.zst ../
popd
rm -rf paru