## dan .dotfiles

Hello there, stranger. Those are my dotfiles.

To help manage those files, I use [Stow](https://www.gnu.org/software/stow).

### Terminal

My setup is very basic: alacritty + zsh + tmux.

#### [Alacritty](https://github.com/alacritty/alacritty)

One day I decided to try Alacritty and got instantly sold. It is **FAST**.

It's very bare bones compared to other terminals, but this is a feature to me.
I don't do much besides configuring a theme and font type/size.
I don't miss anything and I don't need anything else apart from zsh and tmux.

All I want is a fast and reliable terminal. Alacritty is that terminal.

For my fonts, I use and **recommend**
[JetBrainsMono Nerd Fonts](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/JetBrainsMono.zip).

You can find my configuration for Alacritty
[here](/alacritty/.config/alacritty/alacritty.toml).

#### [tmux](https://github.com/tmux/tmux/wiki)

I'm by no means an advanced tmux user and my usage is very basic. This is also
the case for my [configuration](./tmux/.tmux.conf).

#### zsh

I absolutely **LOVE** zsh bundled with [Oh My Zsh](https://ohmyz.sh).
Add [PowerLevel10k](https://github.com/romkatv/powerlevel10k) on top of it and
BANG!

Arnold Schwarzenegger describes the feeling perfectly
[here](https://www.youtube.com/watch?v=hrJ5s_0mylg). Yeah Arnold, I feel it too.

You can find my setup [here](/zsh/.zshrc).

### Git

I keep my common configuration under the usual .gitconfig and if I have
the need to define specific information (work/personal), I setup additional
.gitconfig-work/personal files for that.

I use [delta](https://github.com/dandavison/delta) for cli diffs.

For authentication/signing, I use and **recommend** physical security keys like
the [YubiKey](https://www.yubico.com/products/yubikey-5-overview/).
Once everything is configured it is quite fun (and safe). You feel like a
secret agent.

You can find my default configuration [here](/git/.gitconfig).

### [Neovim](https://neovim.io/)

I love JetBrains IDEs but after spending some time in neovim with tree-sitter
and lsps, I can't go back. So much so that I use it even for .net development.

You can find my neovim configuration [here](/nvim/.config/nvim).

### Theme - [Kanagawa](https://github.com/rebelot/kanagawa.nvim)

While looking for neovim colorschemes, I stumbled upon rebelot/kanagawa.nvim
and immediately fell in love, as I'm a big Hokusai admirer and have some prints
myself. I try to use it everywhere is possible.
