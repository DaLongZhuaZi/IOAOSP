#!/bin/bash

# 显示选择界面
CHOICE=$(dialog --clear --backtitle "安卓/鸿蒙补完计划" \
    --title "IOAOSP" \
    --menu "请选择功能:" 15 40 4 \
    1 "可执行的脚本列表" \
    2 "更新本工具" \
    3 "初始化工具（仅需执行一次）" \
    4 "退出" \
3>&1 1>&2 2>&3)

# 根据用户选择执行相应的操作
case $CHOICE in
    1)
        echo "执行操作1"
        # 在这里添加操作1的代码
    ;;
    2)
        echo "正在删除本地文件并更新"
        rm -rf /root/IOAOSP
        git clone https://github.com/DaLongZhuaZi/IOAOSP.git
    ;;
    3)
        echo "执行操作3"
        sed -i '15i\
        # 定义 DLZZ 命令\
        DLZZ() {\
                sh /root/IOAOSP/DLZZ.sh\
        }' /etc/zsh/zshrc
        . /etc/zsh/zshrc
    ;;
    4)
        echo "退出"
    ;;
    *)
        echo "未知选项"
    ;;
esac
