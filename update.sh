source ./DLZZ.sh

execute_option_2() {
    # 在这里添加操作2的代码
    git pull origin main
    chmod +x /root/IOAOSP/DLZZ.sh
    chmod +x /root/IOAOSP
    # 定义版本号
    VERSION="0.5"
    
    # 存储版本号到变量
    script_version="$VERSION"
    
    # 向 /root 写入版本信息文件
    echo "$script_version" > /root/script_version.txt
    
    # 获取当前脚本的绝对路径
    script_path=$(realpath "$0")
    
    # 读取版本信息到变量
    if [ -f /root/script_version.txt ]; then
        script_version=$(cat /root/script_version.txt)
    else
        script_version="未知版本"  # 或者设置一个默认值
    fi
    
    # 弹出确认窗口，显示版本信息
    dialog --clear --backtitle "DaLongZhuaZi" --title "更新完成" --msgbox "版本：$script_version\n更新完成，脚本将自动重启" 10 50
    
    # 自动重启脚本
    exec "$script_path" "$@"
}