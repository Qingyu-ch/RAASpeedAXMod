#!/system/bin/sh
# Restore Animations Custom — AxManager plugin
# 从 config.conf 读取自定义缩放值并应用（支持 CRLF/LF 换行）

MODDIR=${0%/*}
CONFIG_FILE="$MODDIR/config.conf"

echo "[RestoreAnim] Reading custom animation scales from config.conf..."
echo ""

# 默认值（当配置缺失或无法读取时使用）
DEFAULT_WINDOW=1
DEFAULT_TRANSITION=1
DEFAULT_ANIMATOR=1

# 初始化变量（后续从配置覆盖）
WINDOW=$DEFAULT_WINDOW
TRANSITION=$DEFAULT_TRANSITION
ANIMATOR=$DEFAULT_ANIMATOR

# 尝试加载配置文件
if [ -f "$CONFIG_FILE" ]; then
    while IFS='=' read -r key value; do
        # 跳过空行和注释（以#开头）
        case "$key" in
            ''|\#*) continue ;;
        esac
        # 去除首尾空白，并强制删除回车符 \r（兼容 CRLF 换行）
        key=$(echo "$key" | tr -d '\r' | xargs)
        value=$(echo "$value" | tr -d '\r' | xargs)
        case "$key" in
            window_animation_scale) WINDOW="$value" ;;
            transition_animation_scale) TRANSITION="$value" ;;
            animator_duration_scale) ANIMATOR="$value" ;;
        esac
    done < "$CONFIG_FILE"
    echo "[OK] Loaded config from $CONFIG_FILE"
else
    echo "[WARN] config.conf not found, using defaults (1.0x)"
fi

echo "Using values:"
echo "  window_animation_scale      = $WINDOW"
echo "  transition_animation_scale  = $TRANSITION"
echo "  animator_duration_scale     = $ANIMATOR"
echo ""

# 应用三个缩放值
for entry in "window_animation_scale:$WINDOW" "transition_animation_scale:$TRANSITION" "animator_duration_scale:$ANIMATOR"; do
    scale="${entry%%:*}"
    desired="${entry##*:}"
    old=$(settings get global "$scale" 2>/dev/null)
    if settings put global "$scale" "$desired" 2>/dev/null; then
        new=$(settings get global "$scale" 2>/dev/null)
        echo "[OK] $scale: $old → $new"
    else
        echo "[FAIL] $scale: 设置失败！可能由于系统限制…… (current: $old)"
        sleep 3
        exit 1
    fi
done

echo ""
echo "[RestoreAnim] 已完成……Done."
sleep 0.5

# 进一步验证写权限（尝试读一个已知值）
test_val=$(settings get global window_animation_scale 2>&1) || {
    echo "[ERROR] Cannot read system settings. Check permission (Shizuku/ADB/Root)."
    echo "权限不足，如果写入成功可能因为系统……模块将在2秒后退出"
    sleep 2
    exit 0
}