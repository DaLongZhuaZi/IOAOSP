#!/bin/bash
source ./app.sh
source ./system.sh
source ./update.sh

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
            execute_option_1
        ;;
        2)
            echo "加载可执行的脚本列表"
            execute_option_4
        ;;
        3)
            echo "正在删除本地文件并更新"
            execute_option_2
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

# 运行主选择界面
while true; do
    main_menu
done
