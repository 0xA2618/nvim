#!/bin/bash

# Linux 通用文件颜色配置脚本
# 适用于任何 Linux 发行版

echo "设置 Linux 文件颜色配置..."

# 1. 设置环境变量 (添加到 ~/.bashrc 或 ~/.zshrc)
cat << 'EOF'
# 文件颜色配置 - 适用于所有 Linux 发行版
export CLICOLOR=1
export LS_COLORS='di=34:fi=0:ln=35:pi=33:so=32:do=35:bd=34;46:cd=34;43:ex=31:*.tar=32:*.tgz=32:*.zip=32:*.gz=32:*.bz2=32:*.xz=32:*.7z=32:*.rar=32:*.deb=32:*.rpm=32:*.jpg=35:*.jpeg=35:*.png=35:*.gif=35:*.bmp=35:*.tiff=35:*.svg=35:*.webp=35:*.ico=35:*.mp3=36:*.wav=36:*.flac=36:*.ogg=36:*.mp4=37:*.avi=37:*.mkv=37:*.mov=37:*.wmv=37:*.flv=37:*.webm=37:*.pdf=33:*.ps=33:*.djvu=33:*.chm=33:*.txt=36:*.md=36:*.rst=36:*.doc=33:*.docx=33:*.odt=33:*.xls=33:*.xlsx=33:*.ods=33:*.ppt=33:*.pptx=33:*.odp=33:*.c=36:*.cpp=36:*.cxx=36:*.cc=36:*.h=36:*.hpp=36:*.hxx=36:*.py=36:*.pyc=36:*.pyo=36:*.js=36:*.jsx=36:*.ts=36:*.tsx=36:*.html=36:*.htm=36:*.css=36:*.scss=36:*.sass=36:*.less=36:*.json=36:*.xml=36:*.yaml=36:*.yml=36:*.toml=36:*.ini=36:*.conf=36:*.cfg=36:*.sh=36:*.bash=36:*.zsh=36:*.fish=36:*.rb=36:*.php=36:*.java=36:*.class=36:*.jar=36:*.go=36:*.rs=36:*.swift=36:*.kt=36:*.scala=36:*.clj=36:*.hs=36:*.ml=36:*.lisp=36:*.el=36:*.vim=36:*.pl=36:*.pm=36:*.t=36:*.sql=36:*.r=36:*.R=36:*.m=36:*.matlab=36:*.tex=36:*.bib=36:*.log=31:*.err=31:*.out=31:*.tmp=90:*.temp=90:*.bak=90:*.old=90:*.orig=90:*.swp=90:*.swo=90:*.lock=90'

# 启用颜色支持
if [ -n "$BASH_VERSION" ]; then
    # Bash 配置
    alias ls='ls --color=auto'
    alias ll='ls -l --color=auto'
    alias la='ls -la --color=auto'
    alias l='ls -l --color=auto'
    alias grep='grep --color=auto'
    alias egrep='egrep --color=auto'
    alias fgrep='fgrep --color=auto'
elif [ -n "$ZSH_VERSION" ]; then
    # Zsh 配置
    autoload -U colors && colors
    alias ls='ls --color=auto'
    alias ll='ls -l --color=auto'
    alias la='ls -la --color=auto'
    alias l='ls -l --color=auto'
fi

# 文件类型颜色说明函数
filecolor_info() {
    echo "Linux 文件类型颜色配置："
    echo "📁 目录: 蓝色 (34)"
    echo "🔗 符号链接: 紫色 (35)"
    echo "⚙️  可执行文件: 红色 (31)"
    echo "📦 压缩文件: 绿色 (32)"
    echo "🖼️  图片文件: 紫色 (35)"
    echo "🎵 音频文件: 青色 (36)"
    echo "🎬 视频文件: 白色 (37)"
    echo "📄 文档文件: 黄色 (33)"
    echo "💻 代码文件: 青色 (36)"
    echo "📝 日志文件: 红色 (31)"
    echo "🗂️  备份文件: 亮灰色 (90)"
}
EOF

echo ""
echo "配置已生成！请根据你的 shell 类型选择安装方式："
echo ""
echo "🔧 安装方法："
echo ""
echo "1. 对于 Bash 用户 (大多数 Linux 默认):"
echo "   echo '上述配置内容' >> ~/.bashrc"
echo "   source ~/.bashrc"
echo ""
echo "2. 对于 Zsh 用户:"
echo "   echo '上述配置内容' >> ~/.zshrc"
echo "   source ~/.zshrc"
echo ""
echo "3. 临时测试 (当前会话有效):"
echo "   复制上述配置内容到终端执行"
echo ""
echo "4. 全局系统配置 (需要 root 权限):"
echo "   sudo nano /etc/bash.bashrc  # 添加到系统级配置"
echo "   sudo nano /etc/zsh/zshrc    # Zsh 系统配置"
echo ""
echo "🎨 颜色代码说明："
echo "   30=黑色 31=红色 32=绿色 33=黄色"
echo "   34=蓝色 35=紫色 36=青色 37=白色"
echo "   90=亮黑 91=亮红 92=亮绿 93=亮黄"
echo "   94=亮蓝 95=亮紫 96=亮青 97=亮白"
echo ""
echo "✅ 验证安装:"
echo "   ls -la          # 查看彩色文件列表"
echo "   filecolor_info  # 显示颜色说明"
