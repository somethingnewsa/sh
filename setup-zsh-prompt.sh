#!/usr/bin/env bash
# setup-zsh-prompt.sh - 替换 p10k 为简洁 user@host:path$ 提示符
set -e

ZSHRC="$HOME/.zshrc"
CACHYOS_CFG="/usr/share/cachyos-zsh-config/cachyos-config.zsh"
P10K_LINE='source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme'

prompt_block=$(cat <<'EOF'

# Simple prompt (added by setup-zsh-prompt.sh)
PROMPT='%F{yellow}%n%F{white}@%F{green}%m%F{white}:%F{blue}%~%F{white}$ '
RPROMPT='%F{red}%(?..✘ %?)%f'
EOF
)

# 1) ~/.zshrc: 注释 p10k 加载，加入 PROMPT
touch "$ZSHRC"
if grep -qF '[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh' "$ZSHRC"; then
    sed -i 's|^\(\[\[ ! -f ~/.p10k.zsh \]\] || source ~/.p10k.zsh\)$|# \1|' "$ZSHRC"
fi
if ! grep -qF 'setup-zsh-prompt.sh' "$ZSHRC"; then
    printf '%s\n' "$prompt_block" >> "$ZSHRC"
fi

# 2) cachyos-config.zsh: 注释系统级 p10k 加载（需 sudo）
if [[ -f "$CACHYOS_CFG" ]] && grep -qF "$P10K_LINE" "$CACHYOS_CFG"; then
    if [[ $EUID -eq 0 ]]; then
        sed -i "s|^${P10K_LINE}\$|# &|" "$CACHYOS_CFG"
    elif command -v sudo >/dev/null 2>&1; then
        sudo -n sed -i "s|^${P10K_LINE}\$|# &|" "$CACHYOS_CFG" || {
            echo "需要 sudo 权限修改 $CACHYOS_CFG，请手动执行："
            echo "  sudo sed -i 's|^${P10K_LINE}\$|# &|' $CACHYOS_CFG"
        }
    fi
fi

echo "完成。运行: source ~/.zshrc"