## dbitt .dotfiles

Hello there, stranger. Those are my dotfiles.

To help manage those files, I use [Stow](https://www.gnu.org/software/stow).

### Terminal

The setup is simple: ghostty + fish.

#### Ghostty

I used alacritty coupled with tmux for a very long time, but recently I decided to ditch tmux and
picked [Ghostty](https://github.com/ghostty-org/ghostty).

It is fast, works well in both macos and linux and has tabs, which I use to "replace" tmux.
I also believe it will improve dramatically over the years given how popular it is.

For my fonts, I use
[JetBrainsMono Nerd Fonts](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/JetBrainsMono.zip).

You can find my configuration for Ghostty [here](/ghostty/.config/ghostty/config).

#### Fish

I've always used zsh as my shell but I never really liked how I had to configure it.
The configuration was ugly, convoluted and I also had to rely on plugins with massive independent
configuration files I had no idea what they were doing.

One day I decided to try [fish](https://fishshell.com) and loved it!
Its pretty amazing out-of-the-box: it comes with syntax-highlighting, auto-completion, suggestions,
script formatter (fish language), etc.

But more importantly, configuring it is **so much easier**. Now my configuration is small, written
by ME and I actually understand what it does. Pretty dope.

You can find my setup [here](/fish/.config/fish/config.fish).

### Git

I keep my common configuration under the usual .gitconfig and if I have the need to define
specific information (work/personal), I setup additional .gitconfig-work/personal files for that.

I use [delta](https://github.com/dandavison/delta) for cli diffs.

For authentication/signing, I use and **recommend** physical security keys like
the [YubiKey](https://www.yubico.com/products/yubikey-5-overview/).
Once everything is configured it is quite fun (and safe). You feel like a secret agent.

You can find my default configuration [here](/git/.gitconfig).

### Editor

I love JetBrains IDEs but after spending some time in [Neovim](https://neovim.io/) with tree-sitter
and lsps, I can't go back. So much so that I use it even for .net development.

You can find my neovim configuration [here](/nvim/.config/nvim).

### Theme - [Kanagawa](https://github.com/rebelot/kanagawa.nvim)

While looking for neovim colorschemes, I stumbled upon rebelot/kanagawa.nvim and immediately fell
in love, as I'm a big Hokusai admirer and have some prints myself.
I try to use it everywhere is possible.
