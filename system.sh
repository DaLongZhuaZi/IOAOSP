source ./DLZZ.sh

execute_option_4() {
    # ��������Ӳ���4�Ĵ���
    CHOICE=$(dialog --clear --backtitle "DaLongZhuaZi" \
        --title "ϵͳ����" \
        --menu "��ѡ��:" 15 40 4 \
        1 "�޸�����ֱ���" \
        2 "����װ�����еĴ���" \
        3 "����������" \
    3>&1 1>&2 2>&3)
    
    case $CHOICE in
        1)
            echo "�޸�����ֱ���"
            execute_4_1
        ;;
        2)
            echo "����װ�����еĴ���"
            execute_4_2
        ;;
        3)
            echo "����������"
        ;;
        *)
            echo "δ֪ѡ��"
        ;;
    esac
}

execute_4_1() {
    # ʹ�� dialog ���������ȷ��������Ч�ķֱ��ʸ�ʽ
    resolution=$(dialog --inputbox "�������µķֱ��ʣ�����:2880x1440���м�ΪСд��ĸx��:" 10 30 --stdout --no-cancel)
    # ���ļ����滻�� 17 �е�����Ϊ�û�����ķֱ���
    sed -i "17s/.*/VNC_RESOLUTION=$resolution/" /usr/local/bin/startvnc
    # ����ȷ�ϴ���
    dialog --clear --backtitle "DaLongZhuaZi" --title "�������" --msgbox "�ֱ���������ɣ�������restartvnc������vnc���񣬰��س�����������" 10 30
}