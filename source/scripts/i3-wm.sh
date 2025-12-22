#!/bin/bash
# i3-wm.sh

# スクリプトをエラーで停止させる
set -e

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
  s/(^b2sums=\(.*?)(\))/\1 \n                    '\''350da3cb6baef9d997d38dda0c434eca12c985ca190192cb9b60ae8167d10f92b971c3b024c1f34c9b9bcee78058c252739cbe78ff0ba5c1527891aebf775d14'\''\2/
' PKGBUILD

# PKGBUILDのpackage()のcd i3の直後にパッチ適用行を追加
sed -i '/^package() {$/,/^}$/ s/cd i3$/&\n  patch -Np1 < ..\/i3.patch/' PKGBUILD

popd