#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# NVIDIA Shader Cache Configuration
# ============================================================
# Prevents NVIDIA driver from evicting shader caches, which
# eliminates re-compilation stutter in DXVK/VKD3D games.
#
# Tested with: Proton, Lutris, Heroic, native OpenGL/Vulkan
# ============================================================

CACHE_SIZE="${CACHE_SIZE:=53687091200}"   # 50 GiB
CACHE_SIZE_READABLE="${CACHE_SIZE_READABLE:=50GiB}"

apply_system_wide() {
    echo "==> Writing to /etc/environment (system-wide)"

    sudo tee -a /etc/environment > /dev/null <<EOF

# NVIDIA shader cache: prevent cleanup, set max size
__GL_SHADER_DISK_CACHE_SIZE=$CACHE_SIZE
__GL_SHADER_DISK_CACHE_SKIP_CLEANUP=1
EOF

    echo "    Done. Settings will apply after next login."
}

apply_user_shell() {
    local rc_file="$HOME/.bashrc"

    echo "==> Writing to $rc_file (per-user shell)"
    echo "" >> "$rc_file"
    echo "# NVIDIA shader cache: prevent cleanup, set max size" >> "$rc_file"
    echo "export __GL_SHADER_DISK_CACHE_SIZE=$CACHE_SIZE" >> "$rc_file"
    echo "export __GL_SHADER_DISK_CACHE_SKIP_CLEANUP=1" >> "$rc_file"
    echo "    Done."

    # Source immediately so current shell picks it up
    export __GL_SHADER_DISK_CACHE_SIZE="$CACHE_SIZE"
    export __GL_SHADER_DISK_CACHE_SKIP_CLEANUP=1
    echo "    Exported in current shell."
}

verify() {
    echo ""
    echo "==> Verification"

    local size="${__GL_SHADER_DISK_CACHE_SIZE:-<unset>}"
    local cleanup="${__GL_SHADER_DISK_CACHE_SKIP_CLEANUP:-<unset>}"

    echo "  __GL_SHADER_DISK_CACHE_SIZE      = $size"
    echo "  __GL_SHADER_DISK_CACHE_SKIP_CLEANUP = $cleanup"

    if [ -d "$HOME/.cache/nvidia/GLCache" ]; then
        local cache_size
        cache_size=$(du -sh "$HOME/.cache/nvidia/GLCache" 2>/dev/null | cut -f1)
        echo "  Current GLCache size: $cache_size"
    fi
}

echo "============================================"
echo " NVIDIA Shader Cache Setup"
echo " Cache max size: $CACHE_SIZE_READABLE"
echo " Auto-cleanup:  disabled"
echo "============================================"
echo ""

apply_system_wide
apply_user_shell
verify

echo ""
echo "============================================"
echo " Done. Re-log or reboot to finalize."
echo "============================================"
