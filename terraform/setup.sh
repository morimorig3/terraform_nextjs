#!/bin/bash
# OSのパッケージを最新にアップデート
sudo yum -y update

# curlインストール
sudo apt-get install -y curl

# Node.js のセットアップ
# https://docs.aws.amazon.com/ja_jp/sdk-for-javascript/v2/developer-guide/setting-up-node-on-ec2-instance.html
# nvmインストール
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
source ~/.bashrc
# npm/nodeインストール
nvm install 16


# # nginx存在チェック
# nginx -v

# if [ $? -ne 0 ]; then
#   # nginxインストールなしの場合、インストール実施
#   sudo yum -y install nginx
# fi

# # nginxサービスの自動起動有効化、起動
# sudo systemctl start nginx
# sudo systemctl enable nginx