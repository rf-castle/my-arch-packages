#!/bin/bash
# sway-tabs-render-hidden.sh

# スクリプトをエラーで停止させる
set -e

# patchのコピー
cp "$(dirname "$0")/tabs-render-hidden.patch" $PACKAGE_PATH

# タグ署名(?signed)を検証するための鍵をbuilderに取り込む
sudo -u builder gpg --import "$PACKAGE_PATH"/keys/pgp/*.asc

# PKGBUILDを編集する
pushd $PACKAGE_PATH

# 置換が空振りしたら止める(公式側のPKGBUILDが変わったとき、素のswayをビルドしないため)
check() {
  grep -qF -- "$1" PKGBUILD || { echo "PKGBUILDの書き換えに失敗: $1"; exit 1; }
}

# パッケージ名を変え、元の名前は_pkgnameに残す
sed -i 's/^pkgname=sway$/pkgname=sway-tabs-render-hidden\n_pkgname=sway/' PKGBUILD
check '_pkgname=sway'
sed -i "s/^pkgdesc=.*/pkgdesc='Tiling Wayland compositor (with tabs_render_hidden and tabs_opacity: draw hidden tabs under translucent windows with per-tab opacity)'/" PKGBUILD
check 'tabs_render_hidden'

# 公式のswayと入れ替えられるようにする
sed -i "s/^provides=('wayland-compositor')$/provides=(\"sway=\$epoch:\$pkgver\" 'wayland-compositor')\nconflicts=('sway')/" PKGBUILD
check "conflicts=('sway')"

# ソースの展開先を$_pkgnameにする
sed -i 's|"git+https://github.com/swaywm/sway.git|"$_pkgname::git+https://github.com/swaywm/sway.git|' PKGBUILD
check '"$_pkgname::git+'

# source行・sha512sums行
# 複数行に渡るため、perlを使って行を追加
perl -0777 -i -pe '
  s/(^source=\([\s\S]*?)(\))/\1\n        "tabs-render-hidden.patch"\2/m
' PKGBUILD
check '"tabs-render-hidden.patch"'
perl -0777 -i -pe '
  s/(^sha512sums=\([\s\S]*?)(\))/\1\n            '\''0412dd0f61e4d121349103c6469e1314075f26a906e8bdfbf4974c4090d7906cb9434e8db308bb9304dc5e9b13a6bff181096cafd3b365effe61583b84dd7909'\''\2/m
' PKGBUILD
check '0412dd0f61e4d121'

# ソースディレクトリの参照を$_pkgnameにする(ライセンスのインストール先は$pkgnameのまま)
sed -i -e 's|cd "\$pkgname"|cd "$_pkgname"|' \
       -e 's|arch-meson build "\$pkgname"|arch-meson build "$_pkgname"|' \
       -e 's|"\$pkgname/LICENSE"|"$_pkgname/LICENSE"|' PKGBUILD
check 'cd "$_pkgname"'
check 'arch-meson build "$_pkgname"'
check '"$_pkgname/LICENSE"'

# prepare()でパッチを当てる
sed -i 's|^\(  patch -Np1 -i "\$srcdir/remove_git_version_format.patch"\)$|&\n  patch -Np1 -i "$srcdir/tabs-render-hidden.patch"|' PKGBUILD
check 'patch -Np1 -i "$srcdir/tabs-render-hidden.patch"'

popd
