# sshキー作成
```
ssh-keygen -t rsa -f ec2-keypair
mv ec2-keypair.pub ec2-keypair ~/.ssh
```

# デプロイ
```
terraform apply
```

## ssh接続
```
ssh -i ~/.ssh/ec2-keypair ec2-user@{パブリック IPv4 アドレス}
```