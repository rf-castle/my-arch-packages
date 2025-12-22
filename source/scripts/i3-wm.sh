#!/bin/bash
# i3-wm.sh

# スクリプトをエラーで停止させる
set -e

# あらかじめperlを入れておかないとパスがうまく設定されなさそうなので
# ここで一度インストールしておく
if ! pacman -Q perl &>/dev/null; then
    sudo pacman -S --noconfirm perl
fi

# patchのコピー
cp "$(dirname "$0")/i3.patch" $PACKAGE_PATH

# PKGBUILDを編集する
pushd $PACKAGE_PATH

# source行
# 複数行に渡るため、perlを使って行を追加
perl -0777 -i -pe '
  s/(^source=\([\s\S]*?)(\))/\1 "i3.patch"\2/m
' PKGBUILD
# i3.patchのb2sums行を追加
perl -i -pe '
  s/(^b2sums=\(.*?)(\))/\1 \n                    '\''4e48e9cd9d83f269ea023f4e6b5104250498757f0af3d72496cb47a5aa60aeb9f0757751e302580e44daca92f7a9843b6cc66c2c53454fef9a871d1a05437bc3'\''\2/
' PKGBUILD

# PKGBUILDのpackage()のcd i3の直後にパッチ適用行を追加
sed -i '/^package() {$/,/^}$/ s/cd i3$/&\n  patch -Np1 < ..\/i3.patch/' PKGBUILD

popd