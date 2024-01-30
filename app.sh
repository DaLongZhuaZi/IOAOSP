source ./DLZZ.sh

execute_option_1() {
    CHOICE=$(dialog --clear --backtitle "DaLongZhuaZi" \
        --title "�ɰ�װ������б�" \
        --menu "��ѡ�����:" 15 40 4 \
        1 "����ϵͳ�������" \
        2 "��װWPS Office" \
        3 "����������" \
    3>&1 1>&2 2>&3)
    
    case $CHOICE in
        1)
            echo "�������������"
            execute_1_1
        ;;
        2)
            echo "��װWPS Office"
            execute_1_2
        ;;
        3)
            echo "����������"
        ;;
        *)
            echo "δ֪ѡ��"
        ;;
    esac
}

execute_1_1() {
    # ����������Ӳ���1-1�Ĵ���
    apt update
    apt upgrade -y
    # ����ȷ�ϴ���
    dialog --clear --backtitle "DaLongZhuaZi" --title "�������" --msgbox "�����������ɣ��밴�س�����������" 10 30
}

execute_1_2() {
    # ����������Ӳ���1-2�Ĵ���
    apt update
    apt install wps-office wps-office-fonts -y
    # ����ȷ�ϴ���
    dialog --clear --backtitle "DaLongZhuaZi" --title "��װ���" --msgbox "WPS��װ��ɣ��밴�س�����������" 10 30
}