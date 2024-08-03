#!/bin/bash
# build.sh

# スクリプトをエラーで停止させる
set -e

# パッケージアップデートとビルドツールのインストール
pacman -Syu --noconfirm
pacman -S --noconfirm base-devel git

# paruのインストール
# Todo: 毎回インストールするのは非効率なので、どっかから持ってくる
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si --noconfirm

# 対象パッケージをビルド
cd $1
paru -B --noconfirm .
