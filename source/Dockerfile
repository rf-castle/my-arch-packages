# ベースイメージの指定
# 処理は全てsetup.shに任せる

FROM archlinux:base-devel

WORKDIR /opt
COPY setup.sh .

RUN chmod +x ./setup.sh && ./setup.sh