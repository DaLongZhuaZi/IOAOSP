source ./DLZZ.sh

execute_option_3() {
    # ��������Ӳ���3�Ĵ���
    chmod +x /root/IOAOSP/DLZZ.sh
    chmod +x /root/IOAOSP
    chmod +x /root/IOAOSP/system.sh
    chmod +x /root/IOAOSP/init.sh
    chmod +x /root/IOAOSP/app.sh
    chmod +x /root/IOAOSP/update.sh

    sed -i '15i\
# ���� DLZZ ����\
DLZZ() {\
        sh /root/IOAOSP/DLZZ.sh\
    }' /etc/zsh/zshrc
    sed -i '16i\
# ���� dlzz ����\
dlzz() {\
        sh /root/IOAOSP/DLZZ.sh\
    }' /etc/zsh/zshrc
    sed -i '17i\
# ���� restartvnc ����\
restartvnc() {
        stopvnc
        startvnc
    }' /etc/zsh/zshrc
    # ����ȷ�ϴ���
    dialog --clear --backtitle "DaLongZhuaZi" --title "��ʼ�����" --msgbox "�����˳����ߺ��ֶ�����source /etc/zsh/zshrc���س�" 10 30
}