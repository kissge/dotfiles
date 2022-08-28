# dotfiles v2

## Installation

Install `git` and `zsh` first, then:

```sh
bash -c "$(curl -fsSL https://raw.githubusercontent.com/kissge/dotfiles/master/setup.sh)"
```

## Contents

```
dotfiles/
├── setup.sh ........ Automatic installation script
│
├── zsh ............. Configuration files
├── git
├── tmux
│
├── bin ............. Useful scripts I personally use
│                     (Stand-alone)
├── lib ............. (Intended to be included in scripts)
│
├── macos ........... OS-specific configuration files (not well managed)
├── linux
└── windows
```

## License

The contents of this repository, except for files under the `bin/vendor` directory, are licensed under [the MIT License](./LICENSE.txt).
For the exceptional files’ license, please refer to the commit message of the commit that adds the file.

©︎ 2022 Yusuke Kido.
