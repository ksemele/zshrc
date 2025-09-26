# How to

Clone this repo to `$HOME`.
Create `$HOME/.private.zshrc` with keys and tokens.
Add extra files to `.zshrc`:
```
cat ~/.zshrc
source $HOME/zshrc/public.zshrc
source $HOME/.private.zshrc

# other specific envs
source $HOME/.project.zshrc
```

```
https://brew.sh
brew install zsh
sudo sh -c "echo $(which zsh) >> /etc/shells"
chsh -s $(which zsh)

https://starship.rs/installing/
mkdir -p $HOME/.config && ln starship.toml $HOME/.config/starship.toml

brew install zoxide

brew install fzf
To set up shell integration, see:
  https://github.com/junegunn/fzf#setting-up-shell-integration
To use fzf in Vim, add the following line to your .vimrc:
  set rtp+=/opt/homebrew/opt/fzf

https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html

brew install kubectl
brew install derailed/k9s/k9s
brew install tree
brew install skopeo
```

# todo
- [x] init version
- [ ] list of tools with links/commands
- [ ] refatcor zsh aliases
- [ ] add automation for saving (?)
