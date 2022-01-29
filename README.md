# dredd_cmd

dreddを簡単に使えるようにしたシェルスクリプトです。

## Requirement

Docker `v 20.10.0` 以降

## 準備

openapiのymlファイルがある場所へ移動し、そこで `git clone` をしてください。

例えば `openapi/default.yml` がOASであれば、以下のようにします。

```
cd openapi
git clone git@github.com:itsuki-n22/dredd_cmd.git
```

以下のようなディレクトリ構成になるように注意してください。

```
openapi/default.yml
openapi/dredd_cmd/*
```

## 設定方法

#### params.cfg について

params.cfgを設定することで、検証先のAPIのURL、OASのファイル名などを指定します。

Dockerを利用しているので、API_URLのホストはhost.docker.internalを指定しています。

**Dockerのバージョンが古いとこのホスト名が使えないので、Dockerは v 20.10.0 以降のものを利用してください。**

```
# openapi(OAS)のファイル名 
FILE='default.yml'

# hookファイル
# *.jsとすることで複数のファイルを指定可能
HOOKFILES='*.js'

# dredd.sh があるディレクトリの名前
DREDD_DIR='dredd_cmd'

# OpenAPIのURLではなく、APIのURLを書く。 
# Dockerからの通信なので、ホストマシンのlocalhostにアクセスする場合以下のように書く
# 例： API_URL='http://host.docker.internal:8000/api/'
API_URL='http://host.docker.internal:8000/api/'
```

#### テストを制御したい

`dredd_cmd/hooks/hook.js` を調整することでテストの挙動を変更できます。

細かく制御する場合は、中身を確認していただけると嬉しいです。

例えば、hook.js では、401のレスポンスのテストはスキップするように設定してあります。

各APIのリクエストごとにテストを制御可能ですが、それにはリクエスト名が必要です。

リクエスト名は 

```
sh openapi/dredd_cmd/dredd-names.sh
```

で取得可能です。


## 利用方法

```
sh openapi/dredd_cmd/dredd.sh
```


## その他

dreddのログはとても長いので、 `dredd_cmd/tmp/dredd_result.txt` に詳細が出力されます。

OASが分割されているとdreddは利用できないので、swagger-mergerで統合するように設定されています。

## dreddの注意点

OASが推奨される文法通りに書かれていないと dredd が走りません。

よくあるのが description の項目がない場合、 object が正しく設定されていない場合、 exampleの値が指定されていない場合 などです。

`dredd_cmd/tmp/dredd_result.txt` などを確認してみてください。

