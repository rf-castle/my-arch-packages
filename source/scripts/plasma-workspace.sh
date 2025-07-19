#!/bin/bash
# plasma-workspace.sh

# スクリプトをエラーで停止させる
set -e

# あらかじめplasma-workspaceを入れておかないと「error: duplicate packages: plasma-workspace」になるので、
# ここで一度インストールしておく
if ! pacman -Q plasma-workspace &>/dev/null; then
    sudo pacman -S --noconfirm plasma-workspace
fi

# patchのコピー
cp "$(dirname "$0")/plasma-shutdown.patch" $PACKAGE_PATH

# PKGBUILDを編集する
pushd $PACKAGE_PATH

# source行
sed -i 's|^source=\((.*?)\)|source=(\1 plasma-shutdown.patch)|' PKGBUILD
# sha256sums行
# 複数行に渡るため、awkを使って行を追加
perl -0777 -i -pe '
  s/(^sha256sums=\([\s\S]*?)(\))/\1\n            '\''15911ec23da41065fe8c96ec62bfabf9c02d97b90f735fa60692dffec80539b5'\''\2/m
' PKGBUILD

# build関数の中にパッチを適用する行を追加
perl -i -pe '
  s/(^build\(\)\s*\{)/\1\n  pushd "\${pkgname}-\${pkgver}"\n  patch -p1 < "\$srcdir\/plasma-shutdown.patch"\n  popd/m
' PKGBUILD
# cmakeの job数を設定
sed -i 's|cmake --build build|cmake --build build -j $(nproc)|' PKGBUILD
popd