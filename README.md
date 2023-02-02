# Rails Grandmenuアプリ

## 初期環境構築
下記のファイルを準備

```text
.
├── Gemfile.lock
├── Gemfile
├── Dockerfile
└── docker-compose.yml
```

#### Gemfile.lock

空ファイル

#### Gemfile

```Gemfile
source 'https://rubygems.org'
gem 'rails', '7.0.4'
```

#### Dockerfile

```Dockerfile
FROM ruby:3.1.2

RUN mkdir /grandmenuapp
WORKDIR /grandmenuapp
COPY Gemfile /grandmenuapp/Gemfile
COPY Gemfile.lock /grandmenuapp/Gemfile.lock

# Bundlerの不具合対策(1)
RUN apt-get update && \
    apt-get install -y tzdata && \
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && apt-get install -y nodejs && \
    npm install --global yarn && \
    gem update --system && \
    bundle update --bundler && \
    bundle install

COPY . /grandmenuapp
```

#### docker-compose.yml

```YAML
version: '3'
services:
  db:
    # コンテナ名の指定
    container_name: rails_grandmenuapp_db
    image: mysql:8.0
    platform: linux/amd64
    # DBのレコードが日本語だと文字化けするので、utf8をセットする
    command: mysqld --character-set-server=utf8 --collation-server=utf8_unicode_ci
    environment:
      MYSQL_ROOT_PASSWORD: password
      MYSQL_DATABASE: root
      TZ: "Asia/Tokyo"
    ports:
      - "3306:3306"
    # ローカルにDBを持つ
    volumes:
      - ./tmp/db:/var/lib/mysql

  webapl:
    # コンテナ名の指定
    container_name: rails_grandmenuapp_webapl
    build: .
    image: rails_image
    command: bash -c "rm -f tmp/pids/server.pid && bundle exec rails s -p 3000 -b '0.0.0.0'"
    volumes:
      - .:/grandmenuapp
    env_file:
      - .env
    ports:
      - "3000:3000"
    depends_on:
      - db
```

`.env`ファイルにDBのパス設定諸々を記載しておく

```txt
DB_USERNAME="root"
DB_PASSWORD="password"
DB_HOST="db"
```

DB_PASSWORDは`docker-compose.yml`で設定した`MYSQL_ROOT_PASSWORD`  
hostはdockerコンテナのサービス名

### プロジェクトの作成

```bash
docker-compose run webapl rails new . --force --no-deps --database=mysql --css bootstrap
```

▶ ここで一旦gitへ登録しておく (この際railsアプリケーションディレクトリに作成された`.git`は削除しておく)

### イメージの構築

```bash
docker-compose build
```

### DBの設定

`config/database.yml`の編集

```YAML
default: &default
  adapter: mysql2
  encoding: utf8mb4
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  username: <%= ENV['DB_USERNAME'] %>
  password: <%= ENV['DB_PASSWORD'] %>
  host: <%= ENV['DB_HOST'] %>
```

### railsの起動

```bash
docker-compose up
```

### DBの作成

コンテナ起動後にDBの作成を行う

```bash
docker-compose exec webapl rails db:create
```

## アプリの作成

### コントローラーの作成

コントローラー名は**複数形**にしておくこと

```bash
docker-compose exec webapl rails g controller todos
```

### モデルの作成

```bash
docker-compose exec webapl rails g model todo title:string content:text status:boolean
```

作成されたマイグレートファイルを下記のように変更

```ruby
class CreateTodos < ActiveRecord::Migration[5.2]
  def change
    create_table :todos do |t|
      t.string :title, null: false
      t.text :content, null: false
      t.boolean :status, default: false

      t.timestamps
    end
  end
end
```

`title`、`content`はNULLを許容しない  
`status`のdefaultをfalseとする

マイグレートの実行

```bash
docker-compose exec webapl rails db:migrate
```

### カスタムCSSの作成

#### Rails7.系の場合

<https://medium.com/@grzegorz.smajdor/rails-7-with-bootstrap-css-52f5468ead38>

`app/assets/stylesheets`配下にカスタムCSSを作成  
(例として`app/assets/stylesheets/base.css`を作成)

`app/assets/config/manifest.js`内に作成したCSS名を追記

```javascript
//= link base.css
```

`app/views/layouts/application.html.erb`で読み込みを行う  
`<head> </head>`内に記載

```html
<%= stylesheet_link_tag "base", "data-turbo-track": "reload" %>
```

#### Rails6.系以前の場合

`app/assets/stylesheets`配下にカスタムSCSSを作成  
(例として`app/assets/stylesheets/base.scss`を作成)

`app/assets/stylesheets/application.scss`内で作成したSCSSをimport

```SCSS
@import "base";
```