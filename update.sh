source ./DLZZ.sh

execute_option_2() {
    # ��������Ӳ���2�Ĵ���
    git pull origin main
    chmod +x /root/IOAOSP/DLZZ.sh
    chmod +x /root/IOAOSP
    # ����汾��
    VERSION="0.5"
    
    # �洢�汾�ŵ�����
    script_version="$VERSION"
    
    # �� /root д��汾��Ϣ�ļ�
    echo "$script_version" > /root/script_version.txt
    
    # ��ȡ��ǰ�ű��ľ���·��
    script_path=$(realpath "$0")
    
    # ��ȡ�汾��Ϣ������
    if [ -f /root/script_version.txt ]; then
        script_version=$(cat /root/script_version.txt)
    else
        script_version="δ֪�汾"  # ��������һ��Ĭ��ֵ
    fi
    
    # ����ȷ�ϴ��ڣ���ʾ�汾��Ϣ
    dialog --clear --backtitle "DaLongZhuaZi" --title "�������" --msgbox "�汾��$script_version\n������ɣ��ű����Զ�����" 10 50
    
    # �Զ������ű�
    exec "$script_path" "$@"
}