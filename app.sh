source ./DLZZ.sh

execute_option_1() {
    CHOICE=$(dialog --clear --backtitle "DaLongZhuaZi" \
        --title "可安装的软件列表" \
        --menu "请选择软件:" 15 40 4 \
        1 "升级系统所有软件" \
        2 "安装WPS Office" \
        3 "返回主界面" \
    3>&1 1>&2 2>&3)
    
    case $CHOICE in
        1)
            echo "升级所有软件包"
            execute_1_1
        ;;
        2)
            echo "安装WPS Office"
            execute_1_2
        ;;
        3)
            echo "返回主界面"
        ;;
        *)
            echo "未知选项"
        ;;
    esac
}

execute_1_1() {
    # 在这里添加子操作1-1的代码
    apt update
    apt upgrade -y
    # 弹出确认窗口
    dialog --clear --backtitle "DaLongZhuaZi" --title "更新完成" --msgbox "更新软件包完成，请按回车返回主界面" 10 30
}

execute_1_2() {
    # 在这里添加子操作1-2的代码
    apt update
    apt install wps-office wps-office-fonts -y
    # 弹出确认窗口
    dialog --clear --backtitle "DaLongZhuaZi" --title "安装完成" --msgbox "WPS安装完成，请按回车返回主界面" 10 30
}