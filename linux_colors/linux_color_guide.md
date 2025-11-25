# Linux 文件颜色配置通用指南

## 快速安装

### 方法 1: 一键安装 (推荐)
```bash
# 下载并运行配置脚本
curl -sSL https://github.com/0xa2618/nvim/linux_colors/linux_colors_setup.sh | bash

# 或者手动执行
wget https://github.com/0xa2618/nvim/linux_colors/linux_colors_setup.sh
chmod +x linux_colors_setup.sh
./linux_colors_setup.sh
```

### 方法 2: 手动配置

#### 对于 Bash (Ubuntu/Debian/CentOS 默认)
```bash
# 添加到 ~/.bashrc
echo 'export LS_COLORS="di=34:fi=0:ln=35:pi=33:so=32:do=35:bd=34;46:cd=34;43:ex=31:*.tar=32:*.tgz=32:*.zip=32:*.gz=32:*.bz2=32:*.xz=32:*.7z=32:*.rar=32:*.deb=32:*.rpm=32:*.jpg=35:*.jpeg=35:*.png=35:*.gif=35:*.bmp=35:*.tiff=35:*.svg=35:*.webp=35:*.ico=35:*.mp3=36:*.wav=36:*.flac=36:*.ogg=36:*.mp4=37:*.avi=37:*.mkv=37:*.mov=37:*.wmv=37:*.flv=37:*.webm=37:*.pdf=33:*.ps=33:*.djvu=33:*.chm=33:*.txt=36:*.md=36:*.rst=36:*.doc=33:*.docx=33:*.odt=33:*.xls=33:*.xlsx=33:*.ods=33:*.ppt=33:*.pptx=33:*.odp=33:*.c=36:*.cpp=36:*.cxx=36:*.cc=36:*.h=36:*.hpp=36:*.hxx=36:*.py=36:*.pyc=36:*.pyo=36:*.js=36:*.jsx=36:*.ts=36:*.tsx=36:*.html=36:*.htm=36:*.css=36:*.scss=36:*.sass=36:*.less=36:*.json=36:*.xml=36:*.yaml=36:*.yml=36:*.toml=36:*.ini=36:*.conf=36:*.cfg=36:*.sh=36:*.bash=36:*.zsh=36:*.fish=36:*.rb=36:*.php=36:*.java=36:*.class=36:*.jar=36:*.go=36:*.rs=36:*.swift=36:*.kt=36:*.scala=36:*.clj=36:*.hs=36:*.ml=36:*.lisp=36:*.el=36:*.vim=36:*.pl=36:*.pm=36:*.t=36:*.sql=36:*.r=36:*.R=36:*.m=36:*.matlab=36:*.tex=36:*.bib=36:*.log=31:*.err=31:*.out=31:*.tmp=90:*.temp=90:*.bak=90:*.old=90:*.orig=90:*.swp=90:*.swo=90:*.lock=90"' >> ~/.bashrc

# 添加别名
echo 'alias ls="ls --color=auto"' >> ~/.bashrc
echo 'alias ll="ls -l --color=auto"' >> ~/.bashrc
echo 'alias la="ls -la --color=auto"' >> ~/.bashrc

# 重新加载配置
source ~/.bashrc
```

#### 对于 Zsh
```bash
# 添加到 ~/.zshrc
echo 'export LS_COLORS="di=34:fi=0:ln=35:pi=33:so=32:do=35:bd=34;46:cd=34;43:ex=31:*.tar=32:*.tgz=32:*.zip=32:*.gz=32:*.bz2=32:*.xz=32:*.7z=32:*.rar=32:*.deb=32:*.rpm=32:*.jpg=35:*.jpeg=35:*.png=35:*.gif=35:*.bmp=35:*.tiff=35:*.svg=35:*.webp=35:*.ico=35:*.mp3=36:*.wav=36:*.flac=36:*.ogg=36:*.mp4=37:*.avi=37:*.mkv=37:*.mov=37:*.wmv=37:*.flv=37:*.webm=37:*.pdf=33:*.ps=33:*.djvu=33:*.chm=33:*.txt=36:*.md=36:*.rst=36:*.doc=33:*.docx=33:*.odt=33:*.xls=33:*.xlsx=33:*.ods=33:*.ppt=33:*.pptx=33:*.odp=33:*.c=36:*.cpp=36:*.cxx=36:*.cc=36:*.h=36:*.hpp=36:*.hxx=36:*.py=36:*.pyc=36:*.pyo=36:*.js=36:*.jsx=36:*.ts=36:*.tsx=36:*.html=36:*.htm=36:*.css=36:*.scss=36:*.sass=36:*.less=36:*.json=36:*.xml=36:*.yaml=36:*.yml=36:*.toml=36:*.ini=36:*.conf=36:*.cfg=36:*.sh=36:*.bash=36:*.zsh=36:*.fish=36:*.rb=36:*.php=36:*.java=36:*.class=36:*.jar=36:*.go=36:*.rs=36:*.swift=36:*.kt=36:*.scala=36:*.clj=36:*.hs=36:*.ml=36:*.lisp=36:*.el=36:*.vim=36:*.pl=36:*.pm=36:*.t=36:*.sql=36:*.r=36:*.R=36:*.m=36:*.matlab=36:*.tex=36:*.bib=36:*.log=31:*.err=31:*.out=31:*.tmp=90:*.temp=90:*.bak=90:*.old=90:*.orig=90:*.swp=90:*.swo=90:*.lock=90"' >> ~/.zshrc

# 启用颜色支持
echo 'autoload -U colors && colors' >> ~/.zshrc
echo 'alias ls="ls --color=auto"' >> ~/.zshrc
echo 'alias ll="ls -l --color=auto"' >> ~/.zshrc
echo 'alias la="ls -la --color=auto"' >> ~/.zshrc

# 重新加载配置
source ~/.zshrc
```

## 不同发行版特殊配置

### Ubuntu/Debian
```bash
# Ubuntu 通常默认已启用颜色
# 检查 ~/.bashrc 中的颜色配置
grep "color" ~/.bashrc

# 如果没有，手动添加
echo 'force_color_prompt=yes' >> ~/.bashrc
```

### CentOS/RHEL/Fedora
```bash
# CentOS 可能需要手动启用
echo 'alias ls="ls --color=auto"' >> ~/.bashrc
source ~/.bashrc
```

### Arch Linux
```bash
# Arch 通常配置较好
# 检查 /etc/skel/.bashrc 作为参考
```

## 颜色代码参考

| 代码 | 颜色 | 用途 |
|------|------|------|
| 30 | 黑色 | - |
| 31 | 红色 | 可执行文件、日志、错误 |
| 32 | 绿色 | 压缩文件 |
| 33 | 黄色 | 文档文件 |
| 34 | 蓝色 | 目录 |
| 35 | 紫色 | 符号链接、图片 |
| 36 | 青色 | 代码文件、音频 |
| 37 | 白色 | 视频文件 |
| 90 | 亮灰 | 备份、临时文件 |

## 验证配置

```bash
# 测试颜色显示
ls -la

# 查看当前 LS_COLORS 设置
echo $LS_COLORS

# 显示颜色说明
filecolor_info
```

## 故障排除

### 问题 1: 颜色没有显示
```bash
# 检查终端支持
echo $TERM
# 应该是 xterm-256color 或类似

# 检查 LS_COLORS 是否设置
echo $LS_COLORS

# 手动启用颜色
ls --color=auto
```

### 问题 2: 某些文件类型没有颜色
```bash
# 检查文件扩展名是否在 LS_COLORS 中
echo $LS_COLORS | tr ':' '\n' | grep "\.py"
```

### 问题 3: 远程连接没有颜色
```bash
# 在 SSH 连接中强制启用颜色
ssh -t user@host 'export TERM=xterm-256color; bash -l'
```

## 高级配置

### 自定义颜色方案
```bash
# 创建个人颜色配置
cat > ~/.dircolors << 'EOF'
# 个人颜色配置
DIR 01;34 # 蓝色目录
LNK 01;36 # 青色链接
EXE 01;32 # 绿色可执行
*.txt 32  # 绿色文本
*.jpg 35  # 紫色图片
EOF

# 加载配置
eval $(dircolors ~/.dircolors)
```

### 主题配色方案
```bash
# Solarized Dark
export LS_COLORS='di=1;34:fi=0:ln=1;36:pi=40;33:so=1;35:do=1;35:bd=40;33;1:cd=40;33;1:ex=1;32:*.tar=1;31:*.tgz=1;31:*.zip=1;31:*.gz=1;31:*.bz2=1;31:*.deb=1;31:*.rpm=1;31:*.jpg=1;35:*.png=1;35:*.gif=1;35:*.bmp=1;35:*.ppm=1;35:*.tga=1;35:*.xbm=1;35:*.xpm=1;35:*.tif=1;35:*.png=1;35:*.mpg=1;37:*.avi=1;37:*.gl=1;37:*.dl=1;37:*.pdf=1;33:*.ps=1;33:*.txt=1;36:*.patch=1;34:*.diff=1;34:*.log=1;33:*.h=1;36:*.c=1;36:*.cpp=1;36:*.py=1;36:*.html=1;36:*.css=1;36:*.js=1;36'

# Solarized Light  
export LS_COLORS='di=1;34:fi=0:ln=1;36:pi=40;33:so=1;35:do=1;35:bd=40;33;1:cd=40;33;1:ex=1;32:*.tar=1;31:*.tgz=1;31:*.zip=1;31:*.gz=1;31:*.bz2=1;31:*.deb=1;31:*.rpm=1;31:*.jpg=1;35:*.png=1;35:*.gif=1;35:*.bmp=1;35:*.ppm=1;35:*.tga=1;35:*.xbm=1;35:*.xpm=1;35:*.tif=1;35:*.png=1;35:*.mpg=1;37:*.avi=1;37:*.gl=1;37:*.dl=1;37:*.pdf=1;33:*.ps=1;33:*.txt=1;36:*.patch=1;34:*.diff=1;34:*.log=1;33:*.h=1;36:*.c=1;36:*.cpp=1;36:*.py=1;36:*.html=1;36:*.css=1;36:*.js=1;36'
```

这个配置适用于所有主流 Linux 发行版，支持 Bash 和 Zsh，并且包含了详细的文件类型颜色分类。
