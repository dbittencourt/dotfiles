## dan .dotfiles

Hello there and welcome to my dotfiles!
It consists of my terminal, git and text-editor configuration.

To help manage those files, I use [Stow](https://www.gnu.org/software/stow).

### Terminal

My setup is very basic: alacritty + zsh + tmux.

#### [Alacritty](https://github.com/alacritty/alacritty)

Recently I tried Alacritty and never looked back. It is **FAST**.

It's very bare bones compared to other terminals like iTerm2, but for me, this
is a feature. I don't even use tabs. All I do is configure a theme and the font
type/size. I don't miss anything and I don't need anything else apart from tmux
and zsh.

All I want is a fast and reliable terminal. Alacritty is that terminal.

For my fonts, I use and **recommend**
[MesloLGS NF](https://github.com/romkatv/dotfiles-public/blob/master/.local/share/fonts/NerdFonts/MesloLGS%20NF%20Regular.ttf).

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

I keep my public-facing configuration under the usual .gitconfig and if I have
the need to define sensitive information (work/personal), I setup additional
.gitconfig-work/personal files for that.

I use [delta](https://github.com/dandavison/delta) for cli diffs.
My color scheme is quite ugly at the moment to be fair, but I usually do diffs
inside nvim/jetbrains ides anyway.

For authentication/signing, I use and **recommend** physical security keys like
the [YubikKey](https://www.yubico.com/products/yubikey-5-overview/).
Once everything is configured it is quite fun (and safe). You feel like a
secret agent.

You can find my default configuration [here](/git/.gitconfig).

### [Neovim](https://neovim.io/)

I'm a big fan of Jetbrains IDE's but I recently took a liking for neovim.
It reminds me of my uni days (getting old).

I'm not new to the vim world. I knew beforehand how to quit it and always used
it as the default editor for git merge commits. But I never really used it as
my daily driver. Once I noticed how capable it became with lsps and lua
scripting, I joined the gang too.

You can find my neovim configuration [here](/nvim/.config/nvim).
