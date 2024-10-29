# Neovim

## Install oh-my-zsh

```bash
# oh-my-zsh 
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"


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
# https://github.com/wbthomason/packer.nvim
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
  ~/.local/share/nvim/site/pack/packer/start/packer.nvim
```



### font&icon 

```bash
https://www.nerdfonts.com/font-downloads

下载字体文件FiraCodeNerdFont-Regular.ttf下载之后双击ttf文件点击安装即可添加到系统字体文件中
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



