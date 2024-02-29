#!/bin/bash

# 定义版本号
VERSION="0.4"

# 存储版本号到变量
script_version="$VERSION"

# 向 /root 写入版本信息文件
echo "$script_version" > /root/script_version.txt

# 在/root目录下新建更新脚本文件，并写入内容
cat <<EOL > /root/IOAOSP_update.sh
#!/bin/bash
cd /root/
rm -rf IOAOSP
git clone https://gitee.com/dalongzz/IOAOSP.git
chmod +x /root/IOAOSP/DLZZ.sh
chmod +x /root/IOAOSP
EOL



#配置语言环境
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

main_menu() {
    # 读取版本信息到变量
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

execute_option_1() {
    CHOICE=$(dialog --clear --backtitle "DaLongZhuaZi" \
        --title "可安装的软件列表" \
        --menu "请选择软件:" 15 40 4 \
        1 "升级系统所有软件" \
        2 "安装WPS Office" \
        3 "安装微信" \
        4 "返回主界面"\
    3>&1 1>&2 2>&3)
    
    case $CHOICE in
        1)
            echo "升级所有软件包"
            execute_1_1
        ;;
        2)
            echo "安装WPS Office"
            execute_1_2
        ;;
        3)
            echo "安装微信"
            execute_1_3
        ;;
        4)
            echo "返回主界面"
        ;;
        *)
            echo "未知选项"
        ;;
    esac
}

execute_1_1() {
    # 在这里添加子操作1-1的代码
    apt update
    apt upgrade -y
    # 弹出确认窗口
    dialog --clear --backtitle "DaLongZhuaZi" --title "更新完成" --msgbox "更新软件包完成，请按回车返回主界面" 10 30
}

execute_1_2() {
    # 在这里添加子操作1-2的代码
    apt update
    apt install wps-office wps-office-fonts -y
    # 下载字体补全包
    git clone
    # 解压并移动到指定目录
    tar -xzvf wps-fonts.tar.gz -C /usr/share/fonts/wps-office/
    # 删除
    # 弹出确认窗口
    dialog --clear --backtitle "DaLongZhuaZi" --title "安装完成" --msgbox "WPS安装完成，请按回车返回主界面" 10 30
}

execute_1_3() {
    # 在这里添加子操作1-3的代码
    apt update
    wget https://home-store-packages.uniontech.com/appstore/pool/appstore/c/com.tencent.weixin/com.tencent.weixin_2.1.5_arm64.deb
    sudo dpkg -i com.tencent.weixin_2.1.5_arm64.deb
    apt -f install
    rm -rf com.tencent.weixin_2.1.5_arm64.deb
    # 弹出确认窗口
    dialog --clear --backtitle "DaLongZhuaZi" --title "安装完成" --msgbox "微信Linux安装完成，请按回车返回主界面" 10 30
}

execute_option_2() {
    # 更新工具
    sh /root/IOAOSP_update.sh
    # 弹出确认窗口
    dialog --clear --backtitle "DaLongZhuaZi" --title "更新完成" --msgbox "更新完成，请按回车退出脚本" 10 30
    # 重启脚本
    exit 0
}

execute_option_3() {
    # 初始化
    cat <<EOL >> /etc/zsh/zshrc

# 定义 DLZZ 命令
    DLZZ() {
            sh /root/IOAOSP/DLZZ.sh
            }
# 定义 dlzz 命令
    dlzz() {
            sh /root/IOAOSP/DLZZ.sh
            }
# 定义 restartvnc 命令
    restartvnc() {
            stopvnc
            startvnc
            }

EOL
    # 弹出确认窗口
    dialog --clear --backtitle "DaLongZhuaZi" --title "初始化完成" --msgbox "请在退出工具后手动输入source /etc/zsh/zshrc并回车" 10 30
}

execute_option_4() {
    # 系统功能
    CHOICE=$(dialog --clear --backtitle "DaLongZhuaZi" \
        --title "系统功能" \
        --menu "请选择:" 15 40 4 \
        1 "修改桌面分辨率（使用xfce4桌面）" \
        2 "清理安装过程中的错误" \
        3 "返回主界面" \
    3>&1 1>&2 2>&3)
    
    case $CHOICE in
        1)
            echo "修改桌面分辨率"
            execute_4_1
        ;;
        2)
            echo "清理安装过程中的错误"
            execute_4_2
        ;;
        3)
            echo "返回主界面"
        ;;
        *)
            echo "未知选项"
        ;;
    esac
}

execute_4_1() {
    # 使用 dialog 创建输入框，确保输入有效的分辨率格式
    resolution=$(dialog --inputbox "请输入新的分辨率，例如:2880x1440（中间为小写字母x）:" 10 30 --stdout --no-cancel)
    # 在文件中替换第 17 行的内容为用户输入的分辨率
    sed -i "17s/.*/VNC_RESOLUTION=$resolution/" /usr/local/bin/startvnc
    # 弹出确认窗口
    dialog --clear --backtitle "DaLongZhuaZi" --title "设置完成" --msgbox "分辨率设置完成，请输入restartvnc来重启vnc服务，按回车返回主界面" 10 30
}

# 运行主选择界面
while true; do
    main_menu
done
