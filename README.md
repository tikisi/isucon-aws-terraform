# isucon-aws-terraform

このリポジトリは [momotaro98/isucon-aws-terraform](https://github.com/momotaro98/isucon-aws-terraform) の fork です。

ISUCON の練習環境を AWS EC2 に構築する Terraform 設定です。
共通のリソース定義を `modules/`、大会ごとの実行単位を `env/` に配置します。

```text
README.md
modules/
    ec2/
    security_group/
    subnet/
    vpc/
env/
    isucon12-qualify/
```

各環境が独立した VPC・サブネット・セキュリティグループ・EC2 を作成します。
既定では、同じ AMI からワーカー 3 台とベンチマーカー 1 台を作成します。
大会固有のアプリケーション構成は、利用する AMI に依存します。

## 準備

- Terraform 1.16.3 以上、Git、Python 3 と AWS の認証情報を用意してください。
- リージョンは `ap-northeast-1`、AZ は `ap-northeast-1a` です。
- 各環境の `main.tf` にある S3 backend の `bucket` を、自分が利用する既存バケットに変更してください。state の `key` は環境ごとに分けています。
- SSH 鍵がなければ、次のコマンドで作成します。

```sh
ssh-keygen -t ed25519 -C "isucon_key" -f ~/.ssh/isucon_id_ed25519
```

## 環境の構築

以下はISUCON12 予選環境の例です。

```sh
cd env/isucon12-qualify
# authorized_keys がまだない場合に実行
touch authorized_keys
```

環境ごとの設定は `env/isucon12-qualify/locals.tf` で管理します。
AMI 名・所有者、VPC アドレス、SG 名、インスタンス構成・タイプ・容量をここで設定してください。
AMI は `standalone_ami_name-*` に一致する最新のものを選びます。
AMI の存在と、インスタンスタイプ・容量がその大会に適していることを確認してください。

接続元 CIDR は `locals.tf` に設定します。環境側の `variables.tf` や `terraform.tfvars` は使用しません。

| ローカル値 | 内容 |
| --- | --- |
| `ssh_authorized_keys` | 同じディレクトリの `authorized_keys` から自動で読み込む公開鍵のリスト |
| `access_cidr_blocks` | 接続元 CIDR。複数の場合はカンマ区切り |

公開鍵は各環境の `authorized_keys` に 1 行ずつ登録してください。少なくとも 1 つ必要です。
このファイルは Git 管理対象外で、空行・`#` で始まるコメント行・重複は読み込み時に除外します。

```text
ssh-ed25519 AAAA... member-a
ssh-ed25519 AAAA... member-b
```

すべての鍵を同列に扱い、cloud-init で AMI のデフォルトユーザーに登録します。
`access_cidr_blocks` は SSH・HTTP・HTTPS・MySQL の許可元に使われます。

```sh
terraform init
terraform plan
terraform apply
```

削除も対象の環境ディレクトリで実行します。

```sh
terraform destroy
```


## 環境の追加と検証

`env/` 配下の環境をコピーし、`main.tf` の backend のキーと、`locals.tf` のSG 名・AMI 設定を変更します。
指定する AMI は、[matsuu/aws-isucon](https://github.com/matsuu/aws-isucon/tree/main) の大会別環境を参考に選択してください。

リポジトリ直下でフォーマットし、初期化後に各環境を検証します。

```sh
terraform fmt -recursive
terraform -chdir=env/isucon12-qualify validate
```
