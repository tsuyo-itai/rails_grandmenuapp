# Pin npm packages by running ./bin/importmap

pin "application", preload: true # application.js を読み込みたい

# これで「venderフォルダにあるvue--dist--vue.esm-browser.js.jsファイルをvueというパッケージ名として読み込む」という意味になり、import Vue from "vue"として書けるようになります。
pin "vue", to: "vue--dist--vue.esm-browser.js.js" # @3.2.41

# app/javascript/controllers 配下を読み込みたい
pin_all_from "app/javascript/controllers", under: "controllers" 