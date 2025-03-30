# Neovim

## Install oh-my-zsh

```bash
# oh-my-zsh 
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

or

git clone https://github.com/ohmyzsh/ohmyzsh.git && cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc


# macOs
brew install autojump zsh-syntax-highlighting

# linux
apt install autojump rustc golang neovim

# setting goproxy
echo 'export GOPRIVATE=golang.org,x.tools' >> ~/.zshrc
echo 'export GOPROXY=https://goproxy.cn,direct' >> ~/.zshrc
source ~/.zshrc

# gopls
go install golang.org/x/tools/gopls@latest
echo 'export PATH=$PATH:$(go env GOPATH)/bin' >> ~/.zshrc
source ~/.zshrc

```



## oh-my-zsh setting

```bash
vim .zshrc
export PATH=/opt/homebrew/bin:$PATH
export PATH=$PATH:$(go env GOPATH)/bin

ZSH_THEME="agnoster"

plugins=(
     zsh-autosuggestions
     autojump
     git
     jsontools
)
```



## Download packer Manager

```bash
# download autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# download lua plugs
git clone https://github.com/0xA2618/nvim.git ~/.config/

# https://github.com/wbthomason/packer.nvim
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
  ~/.local/share/nvim/site/pack/packer/start/packer.nvim
  
# nvim && PackerInstall
```



### Packer

```lua
-- You must run this or `PackerSync` whenever you make changes to your plugin configuration
-- Regenerate compiled loader file
:PackerSync

-- Remove any disabled or unused plugins
:PackerClean

-- Clean, then install missing plugins
:PackerInstall

-- Clean, then update and install plugins
-- supports the `--preview` flag as an optional first argument to preview updates
:PackerUpdate

-- Perform `PackerUpdate` and then `PackerCompile`
-- supports the `--preview` flag as an optional first argument to preview updates
:PackerSync

-- Show list of installed plugins
:PackerStatus

-- Loads opt plugin immediately
:PackerLoad completion-nvim ale
```



### Packer

```lua
-- You must run this or `PackerSync` whenever you make changes to your plugin configuration
-- Regenerate compiled loader file
:PackerSync

-- Remove any disabled or unused plugins
:PackerClean

-- Clean, then install missing plugins
:PackerInstall

-- Clean, then update and install plugins
-- supports the `--preview` flag as an optional first argument to preview updates
:PackerUpdate

-- Perform `PackerUpdate` and then `PackerCompile`
-- supports the `--preview` flag as an optional first argument to preview updates
:PackerSync

-- Show list of installed plugins
:PackerStatus

-- Loads opt plugin immediately
:PackerLoad completion-nvim ale
```





### font&icon 

```bash
https://www.nerdfonts.com/font-downloads

下载字体文件FiraCodeNerdFont-Regular.ttf下载之后双击ttf文件点击安装即可添加到系统字体文件中
# 这个主要是为了在本机上显示时一些符号乱码问题
```

### vue plugs
```bash
npm install -g @vue/language-server typescript-language-server
npm install -g typescript-language-server typescript
npm install -g typescript@latest typescript-language-server@latest
npm install -g @vue/language-server

```


## use 

```bsh
 ~/.config/nvim# tree
.
├── init.lua
├── lua
│   ├── basic.lua
│   ├── colorscheme.lua
│   ├── keymappings.lua
│   ├── lsp
│   │   ├── cmp.lua
│   │   ├── setup.lua
│   │   └── ui.lua
│   ├── plugin-config
│   │   ├── autopairs.lua
│   │   ├── bufferline.lua
│   │   ├── dashboard.lua
│   │   ├── git-blame.lua
│   │   ├── git-signs.lua
│   │   ├── highlight.lua
│   │   ├── lspsaga.lua
│   │   ├── lualine.lua
│   │   ├── luasnip.lua
│   │   ├── mason.lua
│   │   ├── myset.lua
│   │   ├── null-ls.lua
│   │   ├── nvim-tree.lua
│   │   ├── nvim-treesitter.lua
│   │   ├── project.lua
│   │   └── telescope.lua
│   └── plugins.lua
└── testgo
    ├── go.mod
    └── main.go

4 directories, 26 files
```



### remove

```bash
apt remove neovim zsh autojump lua5.1 liblua5.1-0-dev luarocks -y 


rm -rf ~/.config/nvim
rm -rf ~/.local/share/nvim
rm -rf ~/.vim
rm -rf ~/.local/share/nvim/site/pack/packer
rm -rf ~/.oh-my-zsh/
rm ~/.zshrc ~/.zsh_history 
chsh -s /bin/bash # 将/bin/bash 设置为系统bash
```

