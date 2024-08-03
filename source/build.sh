#!/bin/bash
# build.sh

# スクリプトをエラーで停止させる
set -e

# paruのインストール(依存パッケージを持ってきながらビルドするため用)
# Todo: 毎回インストールするのは非効率なので、どっかから持ってくる
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si --noconfirm

# 対象パッケージをビルド
cd $1
paru -B --noconfirm .
