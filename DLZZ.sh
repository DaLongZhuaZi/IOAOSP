#!/bin/bash

main_menu() {
    CHOICE=$(dialog --clear --backtitle "安卓/鸿蒙补完计划" \
        --title "IOAOSP" \
        --menu "请选择功能:" 15 40 4 \
        1 "可执行的脚本列表" \
        2 "更新本工具" \
        3 "初始化工具（仅需执行一次）" \
        4 "退出" \
    3>&1 1>&2 2>&3)
    
    case $CHOICE in
        1)
            echo "执行操作1"
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
    # 在这里添加操作1的代码
    
    # 弹出确认窗口
    dialog --clear --backtitle "操作完成" --title "确认" --msgbox "操作1执行完成，请按回车键返回主选择界面" 10 30
}

execute_option_2() {
    # 在这里添加操作2的代码
    rm -rf /root/IOAOSP
    git clone https://github.com/DaLongZhuaZi/IOAOSP.git
    # 弹出确认窗口
    dialog --clear --backtitle "更新完成" --title "确认" --msgbox "更新完成，请按回车返回主界面" 10 30
}

execute_option_3() {
    # 在这里添加操作3的代码
    sed -i '15i\
# 定义 DLZZ 命令\
DLZZ() {\
        sh /root/IOAOSP/DLZZ.sh\
    }' /etc/zsh/zshrc
    # 弹出确认窗口
    dialog --clear --backtitle "初始化完成" --title "确认" --msgbox "完成，请在退出工具后手动输入. /etc/zsh/zshrc并回车" 10 30
}

# 运行主选择界面
while true; do
    main_menu
done
