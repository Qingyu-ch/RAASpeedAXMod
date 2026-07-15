#!/system/bin/sh
# Restore Animations 1.0x — AxManager plugin
# 把开发者选项三个动画缩放还原为 1.0x

echo "- Installing Restore Animations 1.0x"
echo "- Reset window / transition / animator scale to 1.0x"
echo "- Version: v1.1"
echo "- 刷入后点击左下角执行！"

api_level=$(getprop ro.build.version.sdk)
if [ "$api_level" -lt 23 ]; then
    echo " [!] 安卓版本过低！（< 6 . 0 ）模块可能不生效！."
fi