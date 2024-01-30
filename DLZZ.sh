#!/bin/bash
source /root/IOAOSP/app.sh
source /root/IOAOSP/system.sh
source /root/IOAOSP/update.sh

#配置语言环境
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

main_menu() {
    # 读取版本信息
    if [ -f /root/script_version.txt ]; then
        script_version=$(cat /root/script_version.txt)
    else
        script_version="未知版本"
    fi
    # 使用 $script_version 变量在脚本中引用版本号
    CHOICE=$(dialog --clear --backtitle "安卓鸿蒙补完计划 by DaLongZhuaZi" \
        --title "IOAOSP v$script_version" \
        --menu "请选择功能:" 15 40 4 \
        1 "安装软件" \
        2 "系统功能" \
        3 "更新本工具" \
        4 "初始化工具（仅需执行一次）" \
        5 "退出" \
    3>&1 1>&2 2>&3)
    
    case $CHOICE in
        1)
            echo "加载可执行的脚本列表"
            bash ./app.sh
        ;;
        2)
            echo "加载可执行的脚本列表"
            bash ./system.sh
        ;;
        3)
            echo "正在删除本地文件并更新"
            bash ./update.sh
        ;;
        4)
            echo "初始化"
            execute_option_3
        ;;
        5)
            echo "退出"
            exit 0
        ;;
        *)
            echo "未知选项"
        ;;
    esac
}

execute_option_3() {
    # 在这里添加操作3的代码
    chmod +x /root/IOAOSP/DLZZ.sh
    chmod +x /root/IOAOSP
    chmod +x /root/IOAOSP/system.sh
    chmod +x /root/IOAOSP/app.sh
    chmod +x /root/IOAOSP/update.sh

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
    sed -i '17i\
# 定义 restartvnc 命令\
restartvnc() {
        stopvnc
        startvnc
    }' /etc/zsh/zshrc
    # 弹出确认窗口
    dialog --clear --backtitle "DaLongZhuaZi" --title "初始化完成" --msgbox "请在退出工具后手动输入source /etc/zsh/zshrc并回车" 10 30
}

# 运行主选择界面
while true; do
    main_menu
done
