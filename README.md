## はじめに

### 初回のみ

tfenv の利用を推奨します。

Mac の場合は brew でインストールできます。

```sh
brew install tfenv
```

tfenv を使って terraform をインストールします。 
`.terraform-version` に書いてあるバージョンと、同じバージョンの terraform がインストールされます。

```sh
rfenv install
terraform --version                                                                                          [master]
```

プラグイン等のインストール

```sh
terraform init
```

### terraform 実行

planning / dry-run （実際には実行しない）

```sh
terraform plan
```

実行する

```sh
terraform apply
```
