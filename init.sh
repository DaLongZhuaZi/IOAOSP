source ./DLZZ.sh

execute_option_3() {
    # 在这里添加操作3的代码
    chmod +x /root/IOAOSP/DLZZ.sh
    chmod +x /root/IOAOSP
    chmod +x /root/IOAOSP/system.sh
    chmod +x /root/IOAOSP/init.sh
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