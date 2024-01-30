#!/bin/bash

#配置语言环境
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

main_menu() {
    CHOICE=$(dialog --clear --backtitle "安卓/鸿蒙补完计划 by DaLongZhuaZi" \
        --title "IOAOSP v0.1" \
        --menu "请选择功能:" 15 40 4 \
        1 "安装软件" \
        2 "更新本工具" \
        3 "初始化工具（仅需执行一次）" \
        4 "退出" \
    3>&1 1>&2 2>&3)
    
    case $CHOICE in
        1)
            echo "加载可执行的脚本列表"
            execute_option_1
        ;;
        2)
            echo "正在删除本地文件并更新"
            execute_option_2
        ;;
        3)
            echo "初始化"
            execute_option_3
        ;;
        4)
            echo "退出"
            exit 0
        ;;
        *)
            echo "未知选项"
        ;;
    esac
}

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
            execute_o_1
        ;;
        2)
            echo "安装WPS Office"
            execute_o_2
        ;;
        3)
            echo "返回主界面"
        ;;
        *)
            echo "未知选项"
        ;;
    esac
}

execute_o_1() {
    apt update
    apt upgrade -y
    # 弹出确认窗口
    dialog --clear --backtitle "DaLongZhuaZi" --title "更新完成" --msgbox "更新软件包完成，请按回车返回主界面" 10 30
}

execute_o_2() {
    # 在这里添加子操作1-2的代码
    apt update
    apt install wps-office wps-office-fonts -y
    # 弹出确认窗口
    dialog --clear --backtitle "DaLongZhuaZi" --title "安装完成" --msgbox "WPS安装完成，请按回车返回主界面" 10 30
}

execute_option_2() {
    # 在这里添加操作2的代码
    rm -rf /root/IOAOSP
    git clone https://gitee.com/dalongzz/IOAOSP.git
    # 弹出确认窗口
    dialog --clear --backtitle "DaLongZhuaZi" --title "更新完成" --msgbox "更新完成，请按回车返回主界面" 10 30
}

execute_option_3() {
    # 在这里添加操作3的代码
    sed -i '15i\
# 定义 DLZZ 命令\
DLZZ() {\
        sh /root/IOAOSP/DLZZ.sh\
    }' /etc/zsh/zshrc
    sed -i '16i\
# 定义 dlzz 命令\
dlzz() {\
        sh /root/IOAOSP/DLZZ.sh\
    }' /etc/zsh/zshrc
    
    # 弹出确认窗口
    dialog --clear --backtitle "DaLongZhuaZi" --title "初始化完成" --msgbox "请在退出工具后手动输入source /etc/zsh/zshrc并回车" 10 30
}

# 运行主选择界面
while true; do
    main_menu
done
