# Brewfile

## Import (Brewfile -> System)

```
brew bundle --file ~/.config/macos/Brewfile
```

## Export (System -> Brewfile)

```
brew bundle dump --force --all --describe --file ~/.config/macos/Brewfile
```

- 自らコマンドを実行してインストールしたパッケージが列挙され、依存で自動でインストールされたものはちゃんと省いてくれる（っぽい）
- 前者のパッケージを後者の扱いに変えたい場合、 `$(brew --prefix PKGNAME)/INSTALL_RECEIPT.json` を手で編集するしかない
