#!/system/bin/sh
# Restore Animations 1.0x — AxManager plugin
# 把开发者选项三个动画缩放还原为 1.0x

MODDIR=${0%/*}

echo "[RestoreAnim] Resetting animation scales to 1.0x..."
echo ""

# 三个开发者选项对应的 global key
# 1) 窗口动画缩放  2) 过渡动画缩放  3) Animator 时长缩放
for scale in window_animation_scale transition_animation_scale animator_duration_scale; do
    old=$(settings get global "$scale" 2>/dev/null)
    settings put global "$scale" 1
    new=$(settings get global "$scale" 2>/dev/null)
    echo "[RestoreAnim] $scale: $old → $new"
done

echo ""
echo "[RestoreAnim] 已完成……Done."