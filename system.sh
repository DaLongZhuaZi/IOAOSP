source ./DLZZ.sh

execute_option_4() {
    # 在这里添加操作4的代码
    CHOICE=$(dialog --clear --backtitle "DaLongZhuaZi" \
        --title "系统功能" \
        --menu "请选择:" 15 40 4 \
        1 "修改桌面分辨率" \
        2 "清理安装过程中的错误" \
        3 "返回主界面" \
    3>&1 1>&2 2>&3)
    
    case $CHOICE in
        1)
            echo "修改桌面分辨率"
            execute_4_1
        ;;
        2)
            echo "清理安装过程中的错误"
            execute_4_2
        ;;
        3)
            echo "返回主界面"
        ;;
        *)
            echo "未知选项"
        ;;
    esac
}

execute_4_1() {
    # 使用 dialog 创建输入框，确保输入有效的分辨率格式
    resolution=$(dialog --inputbox "请输入新的分辨率，例如:2880x1440（中间为小写字母x）:" 10 30 --stdout --no-cancel)
    # 在文件中替换第 17 行的内容为用户输入的分辨率
    sed -i "17s/.*/VNC_RESOLUTION=$resolution/" /usr/local/bin/startvnc
    # 弹出确认窗口
    dialog --clear --backtitle "DaLongZhuaZi" --title "设置完成" --msgbox "分辨率设置完成，请输入restartvnc来重启vnc服务，按回车返回主界面" 10 30
}