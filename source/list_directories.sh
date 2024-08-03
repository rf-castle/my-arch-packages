#!/bin/bash
# list_directories.sh

# リポジトリのルートディレクトリのサブディレクトリを取得
dirs=$(find . -maxdepth 1 -type d | sed 's|^\./||' | grep -v '^\.git$' | jq -R . | jq -s .)

# JSON形式で出力
echo "{\"dirs\": $dirs}"