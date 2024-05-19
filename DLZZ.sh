#!/bin/zsh

# 定义版本号
ZT_VERSION=null
ZR_VERSION=null
VERSION="0.6.8"
online_version=null
local_version=null
UPDATE="已是最新版本"
ZT_NEW=false
UPDATE=false
change=null
info=null
update_info=null


change=$(cat /root/IOAOSP/change)
local_version=$(cat /root/IOAOSP/version)
# git clone项目到临时目录，获取在线版本号和更新内容
# 检测临时目录是否存在，不存在则创建
if [ ! -d /root/tmp ]; then
    mkdir /root/tmp
fi
cd /root/tmp
git clone https://gitee.com/dalongzz/IOAOSP.git
cd /root/tmp/IOAOSP
# 读取在线版本号
online_version=$(cat version)
# 读取更新内容
info=$(cat change)

# 判断版本
if [ "$online_version" = "$local_version" ]; then
    cd /root
    rm -rf /root/tmp/IOAOSP
else
    UPDATE=true
fi

# 检测/ect/ZT.conf内容是否为"1"，是则写入变量ZT_NEW
if [ -f /etc/ZT.conf ]; then
    if [ "$(cat /etc/ZT.conf)" = "1" ]; then
        ZT_NEW=true
    fi
fi

# 从/etc/ZT.txt文件读取ZT版本号
if [ -f /etc/ZT.txt ]; then
    ZT_VERSION=$(cat /etc/ZT.txt)
fi


# 检测更新脚本是否存在，如果不存在则在/root目录下新建更新脚本文件，并写入内容
if [ ! -f /root/IOAOSP_update.sh ]; then
    echo "#!/bin/bash" > /root/IOAOSP_update.sh
    echo "cd /root/" >> /root/IOAOSP_update.sh
    echo "echo \"清理本地文件\"" >> /root/IOAOSP_update.sh
    echo "rm -rf IOAOSP" >> /root/IOAOSP_update.sh
    echo "echo \"拉取最新版本\"" >> /root/IOAOSP_update.sh
    echo "git clone https://gitee.com/dalongzz/IOAOSP.git" >> /root/IOAOSP_update.sh
    echo "chmod +x /root/IOAOSP/DLZZ.sh" >> /root/IOAOSP_update.sh
    echo "chmod +x /root/IOAOSP" >> /root/IOAOSP_update.sh
    
    chmod +x /root/IOAOSP_update.sh
fi
echo "检测必要依赖"
#检测是否安装dialog
if ! [ -x "$(command -v dialog)" ]; then
    apt update
    apt install dialog -y
fi
#检测是否安装neofetch
if ! [ -x "$(command -v neofetch)" ]; then
    apt update
    apt install neofetch -y
fi
#检测是否安装curl
if ! [ -x "$(command -v curl)" ]; then
    apt update
    apt install curl -y
fi
#检测是否安装wget
if ! [ -x "$(command -v sudo wget)" ]; then
    apt update
    apt install sudo wget -y
fi
#检测是否安装星火应用商店
if [ ! -f /opt/durapps/spark-store/bin/spark-store-console ]; then
    sudo wget -O spark-store-console_4.2.12_all.deb https://gitee.com/spark-store-project/spark-store/releases/download/4.2.12/spark-store-console_4.2.12_all.deb
    sudo dpkg -i spark-store-console_4.2.12_all.deb
    apt -f install -y
    rm -rf spark-store-console_4.2.12_all.deb
fi
# 添加atzlinux源
if [ ! -f /etc/apt/sources.list.d/atzlinux-v11.list ]; then
    sudo wget -c -O atzlinux-v11-archive-keyring_lastest_all.deb https://www.atzlinux.com/atzlinux/pool/main/a/atzlinux-archive-keyring/atzlinux-v11-archive-keyring_lastest_all.deb
    apt -y install ./atzlinux-v11-archive-keyring_lastest_all.deb
    apt update
fi
echo "必要依赖安装完成"

#检测ZT_NEW是否为true，是则进入初始化向导
if [ "$ZT_NEW" = true ]; then
    #修复语言环境
    sudo locale-gen zh_CN.UTF-8
    sudo update-locale LANG=zh_CN.UTF-8
    #进入初始化向导
    CHOICE=$(dialog --clear --backtitle "DaLongZhuaZi" \
        --title "初始化向导" \
        --menu "" 15 45 3 \
        1 "欢迎使用大龙爪子制作的ZT恢复包" \
        2 "本向导将引导您完成一些基本配置" \
        3 "请选择此项以继续"\
    3>&1 1>&2 2>&3)
    case $CHOICE in
        1)
            echo "欢迎使用大龙爪子制作的ZT恢复包"
        ;;
        2)
            echo "本向导将引导您完成一些基本配置"
        ;;
        3)
            echo "请选择此项以继续"
            execute_6
        ;;
        *)
            echo "未知选项"
        ;;
    esac
else
    # 进入主菜单
    main_menu
fi

execute_6_2(){
    #弹出提示信息窗口
    CHOICE=$(dialog --clear --backtitle "DaLongZhuaZi" \
        --title "提示" \
        --menu "" 15 80 7 \
        1 "软件打不开时，请先使用工具内的“修复快捷方式”进行修复" \
        2 "下载软件包时请选择Debian/Ubuntu aarch64/arm64，软件包格式应为deb" \
        3 "如果是自行安装的软件，请右键点击快捷方式，在启动命令末尾添加 --no-sandbox" \
        4 "暂不支持wine等Windows模拟软件，如有需要请了解“Winlator”"\
        5 "恢复包在成功启动桌面环境后即可删除" \
        6 "DLZZ工具内置了一些教程，可稍后在命令行输入DLZZ，选择“常见问题”来查看"\
        7 "已阅读以上内容，开始使用桌面环境"\
    3>&1 1>&2 2>&3)
    case $CHOICE in
        1)
            echo "软件打不开时，请先使用工具内的“修复快捷方式”进行修复"
        ;;
        2)
            echo "下载软件包时请选择Debian/Ubuntu aarch64/arm64，软件包格式应为deb"
        ;;
        3)
            echo "如果是自行安装的软件，请右键点击快捷方式，在启动命令末尾添加 --no-sandbox"
        ;;
        4)
            echo "暂不支持wine等Windows模拟软件，如有需要请了解“Winlator”"
        ;;
        5)
            echo "恢复包在成功启动桌面环境后即可删除"
        ;;
        6)
            echo "DLZZ工具内置了一些教程，可稍后在命令行输入DLZZ，选择“常见问题”来查看"
        ;;
        7)
            echo "请关闭当前窗口"
            # 删除ZT.conf文件
            rm -rf /etc/ZT.conf
            # 退出工具
            exit 0
        ;;
        *)
            echo "未知选项"
        ;;
    esac
}

#进入初始化向导
execute_6() {
    # 检测是否安装WPS
    if [ -f /usr/bin/wps ]; then
        wps_status="已安装"
    else
        wps_status="未安装"
    fi
    # 检测是否安装微信
    if [ -f /opt/wechat-beta/wechat ]; then
        wechat_status="已安装"
    else
        wechat_status="未安装"
    fi
    # 检测是否安装QQ
    if [ -f /opt/QQ/qq ]; then
        qq_status="已安装"
    else
        qq_status="未安装"
    fi
    # 检测是否安装钉钉
    if [ -f /opt/apps/com.alibabainc.dingtalk/files/Elevator.sh ]; then
        dingding_status="已安装"
    else
        dingding_status="未安装"
    fi
    # 检测是否安装CAJ Viewer
    if [ -f /opt/apps/net.cnki.cajviewer/files/cajviewer ]; then
        caj_status="已安装"
    else
        caj_status="未安装"
    fi
    # 检测是否安装华宇拼音输入法
    if [ -f /opt/apps/com.thunisoft.input ]; then
        huayu_status="已安装"
    else
        huayu_status="未安装"
    fi
    
    # 从/etc/ZT.txt文件读取ZT版本号
    if [ -f /etc/ZT.txt ]; then
        ZT_VERSION=$(cat /etc/ZT.txt)
    fi
    
    # 弹出窗口询问用户是否需要安装软件
    CHOICE=$(dialog --clear --backtitle "DaLongZhuaZi" \
        --title "初始化向导 恢复包版本：$ZT_VERSION" \
        --menu "请选择:" 15 75 12 \
        1 "📜安装WPS Office（$wps_status）" \
        2 "📱安装微信Beta版（$wechat_status）" \
        3 "📱安装QQ（$qq_status）" \
        4 "💹安装钉钉（$dingding_status）" \
        5 "🎓安装CAJ Viewer 1.2（$caj_status）" \
        6 "⌨️安装华宇拼音输入法（$huayu_status）" \
        7 "💻安装多款软件（自动安装上述所有软件）" \
        8 "💻修改桌面分辨率（使用VNC连接时有效）" \
        9 "🗔修改显示DPI（所有连接方式可用，及时生效）" \
        10 "❌清理安装过程中的错误" \
        11 "🔙重置xfce桌面设置" \
        12 "下一步" \
    3>&1 1>&2 2>&3)
    
    case $CHOICE in
        1)
            echo "安装WPS Office"
            apt update
            apt install wps-office wps-office-fonts -y
            # 向usr/bin/wpp的第二行写入内容
            sed -i '2i\export QT_QPA_PLATFORMTHEME=qt5ct' /usr/bin/wpp
            sed -i '3i\export QT_SCALE_FACTOR=1' /usr/bin/wpp
            sed -i '4i\export QT_FONT_DPI=200' /usr/bin/wpp
            sed -i '5i\export QT_STYLE_OVERRIDE=kvantum' /usr/bin/wpp
            # 向usr/bin/wps的第二行写入内容
            sed -i '2i\export QT_QPA_PLATFORMTHEME=qt5ct' /usr/bin/wps
            sed -i '3i\export QT_SCALE_FACTOR=1' /usr/bin/wps
            sed -i '4i\export QT_FONT_DPI=200' /usr/bin/wps
            sed -i '5i\export QT_STYLE_OVERRIDE=kvantum' /usr/bin/wps
            # 向usr/bin/wpspdf的第二行写入内容
            sed -i '2i\export QT_QPA_PLATFORMTHEME=qt5ct' /usr/bin/wpspdf
            sed -i '3i\export QT_SCALE_FACTOR=1' /usr/bin/wpspdf
            sed -i '4i\export QT_FONT_DPI=200' /usr/bin/wpspdf
            sed -i '5i\export QT_STYLE_OVERRIDE=kvantum' /usr/bin/wpspdf
        ;;
        2)
            echo "安装微信Beta版"
            echo "开始下载"
            sudo wget -O wechat-beta_1.0.0.150_arm64.deb https://cdn4.cnxclm.com/uploads/2024/03/05/NKX87bHT_wechat-beta_1.0.0.150_arm64.deb
            echo "开始安装"
            sudo dpkg -i wechat-beta_1.0.0.150_arm64.deb
            apt -f install -y
            rm -rf wechat-beta_1.0.0.150_arm64.deb
            # 修补微信运行环境
            git clone https://aur.archlinux.org/wechat-uos.git
            cd wechat-uos
            #解压
            tar -xzvf license.tar.gz
            #复制并覆盖文件
            cp -rf license/etc/* /etc/
            cp -rf license/var/* /var/
            rm -rf /root/桌面/weixin.desktop
            # 重新创建微信桌面快捷方式
            echo "[Desktop Entry]" > /root/桌面/weixin.desktop
            echo "Name=微信" >> /root/桌面/weixin.desktop
            echo "Exec=env QT_QPA_PLATFORMTHEME=qt5ct QT_SCALE_FACTOR=1 QT_FONT_DPI=200 /opt/wechat-beta/wechat --no-sandbox" >> /root/桌面/weixin.desktop
            echo "Terminal=false" >> /root/桌面/weixin.desktop
            echo "Type=Application" >> /root/桌面/weixin.desktop
            echo "Icon=weixin" >> /root/桌面/weixin.desktop
            echo "StartupWMClass=微信" >> /root/桌面/weixin.desktop
            echo "Comment=微信桌面版" >> /root/桌面/weixin.desktop
            echo "Categories=Network" >> /root/桌面/weixin.desktop
            echo "Path=" >> /root/桌面/weixin.desktop
            echo "StartupNotify=false" >> /root/桌面/weixin.desktop
            echo "X-KDE-Protocols=trust" >> /root/桌面/weixin.desktop
            #删除文件
            cd ..
            rm -rf wechat-uos
        ;;
        
        3)
            echo "安装QQ"
            apt install linuxqq -y
            # 添加QQ桌面快捷方式
            echo "[Desktop Entry]" > /root/桌面/QQ.desktop
            echo "Name=QQ" >> /root/桌面/QQ.desktop
            echo "Exec=/opt/QQ/qq --no-sandbox %U" >> /root/桌面/QQ.desktop
            echo "Terminal=false" >> /root/桌面/QQ.desktop
            echo "Type=Application" >> /root/桌面/QQ.desktop
            echo "Icon=QQ" >> /root/桌面/QQ.desktop
            echo "StartupWMClass=QQ" >> /root/桌面/QQ.desktop
            echo "Comment=QQ" >> /root/桌面/QQ.desktop
            echo "Categories=Network" >> /root/桌面/QQ.desktop
            echo "StartupNotify=false" >> /root/桌面/QQ.desktop
            echo "X-KDE-Protocols=trust" >> /root/桌面/QQ.desktop
            
        ;;
        4)
            echo "安装钉钉"
            echo "开始下载"
            sudo wget -O com.alibabainc.dingtalk_7.5.0.40221_arm64.deb https://dtapp-pub.dingtalk.com/dingtalk-desktop/xc_dingtalk_update/linux_deb/Release/com.alibabainc.dingtalk_7.5.0.40221_arm64.deb
            echo "开始安装"
            sudo dpkg -i com.alibabainc.dingtalk_7.5.0.40221_arm64.deb
            apt install libglut3.12 -y
            apt -f install -y
            rm -rf com.alibabainc.dingtalk_7.5.0.40221_arm64.deb
            # 添加钉钉桌面快捷方式
            echo "[Desktop Entry]" > /root/桌面/dingding.desktop
            echo "Name=钉钉" >> /root/桌面/dingding.desktop
            echo "Exec=/opt/apps/com.alibabainc.dingtalk/files/Elevator.sh" >> /root/桌面/dingding.desktop
            echo "Terminal=false" >> /root/桌面/dingding.desktop
            echo "Type=Application" >> /root/桌面/dingding.desktop
            echo "Icon=/opt/apps/com.alibabainc.dingtalk/files/logo.ico" >> /root/桌面/dingding.desktop
            echo "StartupWMClass=钉钉" >> /root/桌面/dingding.desktop
            echo "Comment=钉钉桌面版" >> /root/桌面/dingding.desktop
            echo "Categories=Network" >> /root/桌面/dingding.desktop
            echo "Path=" >> /root/桌面/dingding.desktop
            echo "StartupNotify=false" >> /root/桌面/dingding.desktop
            echo "X-KDE-Protocols=trust" >> /root/桌面/dingding.desktop
            
        ;;
        5)
            echo "安装CAJ Viewer"
            #删除本地文件残留
            rm -rf /opt/apps/net.cnki.cajviewer/
            rm -rf /root/桌面/CAJ.desktop
            rm -rf /root/桌面/CAJ Viewer.desktop
            #获取1.2版本文件
            wget cajviewer_1.2.2-1_arm64.deb https://download.cnki.net/cajPackage/yinHeQiLing/cajviewer_1.2.2-1_arm64.deb
            dpkg -i cajviewer_1.2.2-1_arm64.deb
            rm -rf cajviewer_1.2.2-1_arm64.deb
            #启动脚本
            echo "#!/bin/bash" > /opt/cajviewer/bin/start.sh
            echo "export QT_SCALE_FACTOR=1" >> /opt/cajviewer/bin/start.sh
            echo "export QT_FONT_DPI=200" >> /opt/cajviewer/bin/start.sh
            echo "export QT_STYLE_OVERRIDE=kvantum" >> /opt/cajviewer/bin/start.sh
            echo "export LD_LIBRARY_PATH=/opt/cajviewer/lib:$LD_LIBRARY_PATH" >> /opt/cajviewer/bin/start.sh
            echo "/opt/cajviewer/bin/cajviewer" >> /opt/cajviewer/bin/start.sh
            chmod +x /opt/cajviewer/bin/start.sh
            #快捷方式
            echo "[Desktop Entry]" > /root/桌面/CAJ.desktop
            echo "Name=CAJViewer" >> /root/桌面/CAJ.desktop
            echo "Exec=/opt/cajviewer/bin/start.sh" >> /root/桌面/CAJ.desktop
            echo "Terminal=false" >> /root/桌面/CAJ.desktop
            echo "Type=Application" >> /root/桌面/CAJ.desktop
            echo "Icon=/opt/cajviewer/cajviewer.png" >> /root/桌面/CAJ.desktop
            echo "StartupWMClass=CAJViewer" >> /root/桌面/CAJ.desktop
            echo "Comment=CAJViewer" >> /root/桌面/CAJ.desktop
            echo "Categories=Education" >> /root/桌面/CAJ.desktop
            echo "Version=1.2" >> /root/桌面/CAJ.desktop
            echo "StartupNotify=false" >> /root/桌面/CAJ.desktop
            echo "X-KDE-Protocols=trust" >> /root/桌面/CAJ.desktop
        ;;
        6)
            echo "安装华宇拼音输入法"
            # 安装华宇拼音输入法
            # 询问用户是否需要卸载其他输入法
            CHOICE=$(dialog --clear --backtitle "DaLongZhuaZi" \
                --title "华宇拼音输入法" \
                --menu "是否需要卸载其他输入法:" 15 40 3 \
                1 "是" \
                2 "否" \
                3>&1 1>&2 2>&3)
                    
                    case $CHOICE in
                        1)
                            echo "卸载其他输入法"
                            apt remove --purge fcitx-googlepinyin fcitx-sunpinyin fcitx-libpinyin fcitx-rime -y
                            wget -O HuayuPY_uos_arm_fcitx_2.4.8.207.deb "https://pinyin.thunisoft.com/webapi/v1/downloadSetupFile?os=uos&cpu=arm"
                            dpkg -i HuayuPY_uos_arm_fcitx_2.4.8.207.deb
                            apt -f install -y
                            rm -rf HuayuPY_uos_arm_fcitx_2.4.8.207.deb
                        ;;
                        2)
                            echo "不卸载其他输入法"
                            wget -O HuayuPY_uos_arm_fcitx_2.4.8.207.deb "https://pinyin.thunisoft.com/webapi/v1/downloadSetupFile?os=uos&cpu=arm"
                            dpkg -i HuayuPY_uos_arm_fcitx_2.4.8.207.deb
                            apt -f install -y
                            rm -rf HuayuPY_uos_arm_fcitx_2.4.8.207.deb
                        ;;
                        *)
                            echo "未知选项"
                        ;;
                    esac
            ;;
            7)
                echo "安装多款软件"
                #检测软件安装情况，若已安装则跳过，未安装则自动安装对应软件
                if [ ! -f /usr/bin/wps ]; then
                    apt update
                    apt install wps-office wps-office-fonts -y
                    # 向usr/bin/wpp的第二行写入内容
                    sed -i '2i\export QT_QPA_PLATFORMTHEME=qt5ct' /usr/bin/wpp
                    sed -i '3i\export QT_SCALE_FACTOR=1' /usr/bin/wpp
                    sed -i '4i\export QT_FONT_DPI=200' /usr/bin/wpp
                    sed -i '5i\export QT_STYLE_OVERRIDE=kvantum' /usr/bin/wpp
                    # 向usr/bin/wps的第二行写入内容
                    sed -i '2i\export QT_QPA_PLATFORMTHEME=qt5ct' /usr/bin/wps
                    sed -i '3i\export QT_SCALE_FACTOR=1' /usr/bin/wps
                    sed -i '4i\export QT_FONT_DPI=200' /usr/bin/wps
                    sed -i '5i\export QT_STYLE_OVERRIDE=kvantum' /usr/bin/wps
                    # 向usr/bin/wpspdf的第二行写入内容
                    sed -i '2i\export QT_QPA_PLATFORMTHEME=qt5ct' /usr/bin/wpspdf
                    sed -i '3i\export QT_SCALE_FACTOR=1' /usr/bin/wpspdf
                    sed -i '4i\export QT_FONT_DPI=200' /usr/bin/wpspdf
                    sed -i '5i\export QT_STYLE_OVERRIDE=kvantum' /usr/bin/wpspdf
                fi
                if [ ! -f /opt/wechat-beta/wechat ]; then
                    echo "开始下载"
                    sudo wget -O wechat-beta_1.0.0.150_arm64.deb https://cdn4.cnxclm.com/uploads/2024/03/05/NKX87bHT_wechat-beta_1.0.0.150_arm64.deb
                    echo "开始安装"
                    sudo dpkg -i wechat-beta_1.0.0.150_arm64.deb
                    apt -f install -y
                    rm -rf wechat-beta_1.0.0.150_arm64.deb
                    # 修补微信运行环境
                    git clone https://aur.archlinux.org/wechat-uos.git
                    cd wechat-uos
                    #解压
                    tar -xzvf license.tar.gz
                    #复制并覆盖文件
                    cp -rf license/etc/* /etc/
                    cp -rf license/var/* /var/
                    rm -rf /root/桌面/weixin.desktop
                    # 重新创建微信桌面快捷方式
                    echo "[Desktop Entry]" > /root/桌面/weixin.desktop
                    echo "Name=微信" >> /root/桌面/weixin.desktop
                    echo "Exec=env QT_QPA_PLATFORMTHEME=qt5ct QT_SCALE_FACTOR=1 QT_FONT_DPI=200 /opt/wechat-beta/wechat --no-sandbox" >> /root/桌面/weixin.desktop
                    echo "Terminal=false" >> /root/桌面/weixin.desktop
                    echo "Type=Application" >> /root/桌面/weixin.desktop
                    echo "Icon=weixin" >> /root/桌面/weixin.desktop
                    echo "StartupWMClass=微信" >> /root/桌面/weixin.desktop
                    echo "Comment=微信桌面版" >> /root/桌面/weixin.desktop
                    echo "Categories=Network" >> /root/桌面/weixin.desktop
                    echo "Path=" >> /root/桌面/weixin.desktop
                    echo "StartupNotify=false" >> /root/桌面/weixin.desktop
                    echo "X-KDE-Protocols=trust" >> /root/
                    #删除文件
                    cd ..
                    rm -rf wechat-uos
                fi
                if [ ! -f /opt/QQ/qq ]; then
                    apt install linuxqq -y
                    # 添加QQ桌面快捷方式
                    echo "[Desktop Entry]" > /root/桌面/QQ.desktop
                    echo "Name=QQ" >> /root/桌面/QQ.desktop
                    echo "Exec=/opt/QQ/qq --no-sandbox %U" >> /root/桌面/QQ.desktop
                    echo "Terminal=false" >> /root/桌面/QQ.desktop
                    echo "Type=Application" >> /root/桌面/QQ.desktop
                    echo "Icon=QQ" >> /root/桌面/QQ.desktop
                    echo "StartupWMClass=QQ" >> /root/桌面/QQ.desktop
                    echo "Comment=QQ" >> /root/桌面/QQ.desktop
                    echo "Categories=Network" >> /root/桌面/QQ.desktop
                    echo "StartupNotify=false" >> /root/桌面/QQ.desktop
                    echo "X-KDE-Protocols=trust" >> /root/桌面/QQ.desktop
                fi
                if [ ! -f /opt/apps/com.alibabainc.dingtalk/files/Elevator.sh ]; then
                    echo "开始下载"
                    sudo wget -O com.alibabainc.dingtalk_7.5.0.40221_arm64.deb https://dtapp-pub.dingtalk.com/dingtalk-desktop/xc_dingtalk_update/linux_deb/Release/com.alibabainc.dingtalk_7.5.0.40221_arm64.deb
                    echo "开始安装"
                    sudo dpkg -i com.alibabainc.dingtalk_7.5.0.40221_arm64.deb
                    apt install libglut3.12 -y
                    apt -f install -y
                    rm -rf com.alibabainc.dingtalk_7.5.0.40221_arm64.deb
                    # 添加钉钉桌面快捷方式
                    echo "[Desktop Entry]" > /root/桌面/dingding.desktop
                    echo "Name=钉钉" >> /root/桌面/dingding.desktop
                    echo "Exec=/opt/apps/com.alibabainc.dingtalk/files/Elevator.sh" >> /root/桌面/dingding.desktop
                    echo "Terminal=false" >> /root/桌面/dingding.desktop
                    echo "Type=Application" >> /root/桌面/dingding.desktop
                    echo "Icon=/opt/apps/com.alibabainc.dingtalk/files/logo.ico" >> /root/桌面/dingding.desktop
                    echo "StartupWMClass=钉钉" >> /root/桌面/dingding.desktop
                    echo "Comment=钉钉桌面版" >> /root/桌面/dingding.desktop
                    echo "Categories=Network" >> /root/桌面/dingding.desktop
                    echo "Path=" >> /root/桌面/dingding.desktop
                    echo "StartupNotify=false" >> /root/桌面/dingding.desktop
                    echo "X-KDE-Protocols=trust" >> /root/桌面/dingding.desktop
                fi
                if [ ! -f /opt/apps/com.thunisoft.input ]; then
                    # 安装华宇拼音输入法
                    echo "卸载其他输入法"
                    apt remove --purge fcitx-googlepinyin fcitx-sunpinyin fcitx-libpinyin fcitx-rime -y
                    wget -O HuayuPY_uos_arm_fcitx_2.4.8.207.deb "https://pinyin.thunisoft.com/webapi/v1/downloadSetupFile?os=uos&cpu=arm"
                    dpkg -i HuayuPY_uos_arm_fcitx_2.4.8.207.deb
                    apt -f install -y
                    rm -rf HuayuPY_uos_arm_fcitx_2.4.8.207.deb
                fi
                if [ -f /opt/apps/net.cnki.cajviewer/files/cajviewer ]; then
                    echo "安装CAJ Viewer"
                    #删除本地文件残留
                    rm -rf /opt/apps/net.cnki.cajviewer/
                    rm -rf /root/桌面/CAJ.desktop
                    rm -rf /root/桌面/CAJ Viewer.desktop
                    #获取1.2版本文件
                    wget cajviewer_1.2.2-1_arm64.deb https://download.cnki.net/cajPackage/yinHeQiLing/cajviewer_1.2.2-1_arm64.deb
                    dpkg -i cajviewer_1.2.2-1_arm64.deb
                    rm -rf cajviewer_1.2.2-1_arm64.deb
                    #启动脚本
                    echo "#!/bin/bash" > /opt/cajviewer/bin/start.sh
                    echo "export QT_SCALE_FACTOR=1" >> /opt/cajviewer/bin/start.sh
                    echo "export QT_FONT_DPI=200" >> /opt/cajviewer/bin/start.sh
                    echo "export QT_STYLE_OVERRIDE=kvantum" >> /opt/cajviewer/bin/start.sh
                    echo "export LD_LIBRARY_PATH=/opt/cajviewer/lib:$LD_LIBRARY_PATH" >> /opt/cajviewer/bin/start.sh
                    echo "/opt/cajviewer/bin/cajviewer" >> /opt/cajviewer/bin/start.sh
                    chmod +x /opt/cajviewer/bin/start.sh
                    #快捷方式
                    echo "[Desktop Entry]" > /root/桌面/CAJ.desktop
                    echo "Name=CAJViewer" >> /root/桌面/CAJ.desktop
                    echo "Exec=/opt/cajviewer/bin/start.sh" >> /root/桌面/CAJ.desktop
                    echo "Terminal=false" >> /root/桌面/CAJ.desktop
                    echo "Type=Application" >> /root/桌面/CAJ.desktop
                    echo "Icon=/opt/cajviewer/cajviewer.png" >> /root/桌面/CAJ.desktop
                    echo "StartupWMClass=CAJViewer" >> /root/桌面/CAJ.desktop
                    echo "Comment=CAJViewer" >> /root/桌面/CAJ.desktop
                    echo "Categories=Education" >> /root/桌面/CAJ.desktop
                    echo "Version=1.2" >> /root/桌面/CAJ.desktop
                    echo "StartupNotify=false" >> /root/桌面/CAJ.desktop
                    echo "X-KDE-Protocols=trust" >> /root/桌面/CAJ.desktop
                fi
                if [ ! -f /opt/cajviewer/bin/cajviewer ]; then
                    echo "安装CAJ Viewer"
                    #删除本地文件残留
                    rm -rf /opt/apps/net.cnki.cajviewer/
                    rm -rf /root/桌面/CAJ.desktop
                    rm -rf /root/桌面/CAJ Viewer.desktop
                    #获取1.2版本文件
                    wget cajviewer_1.2.2-1_arm64.deb https://download.cnki.net/cajPackage/yinHeQiLing/cajviewer_1.2.2-1_arm64.deb
                    dpkg -i cajviewer_1.2.2-1_arm64.deb
                    rm -rf cajviewer_1.2.2-1_arm64.deb
                    #启动脚本
                    echo "#!/bin/bash" > /opt/cajviewer/bin/start.sh
                    echo "export QT_SCALE_FACTOR=1" >> /opt/cajviewer/bin/start.sh
                    echo "export QT_FONT_DPI=200" >> /opt/cajviewer/bin/start.sh
                    echo "export QT_STYLE_OVERRIDE=kvantum" >> /opt/cajviewer/bin/start.sh
                    echo "export LD_LIBRARY_PATH=/opt/cajviewer/lib:$LD_LIBRARY_PATH" >> /opt/cajviewer/bin/start.sh
                    echo "/opt/cajviewer/bin/cajviewer" >> /opt/cajviewer/bin/start.sh
                    chmod +x /opt/cajviewer/bin/start.sh
                    #快捷方式
                    echo "[Desktop Entry]" > /root/桌面/CAJ.desktop
                    echo "Name=CAJViewer" >> /root/桌面/CAJ.desktop
                    echo "Exec=/opt/cajviewer/bin/start.sh" >> /root/桌面/CAJ.desktop
                    echo "Terminal=false" >> /root/桌面/CAJ.desktop
                    echo "Type=Application" >> /root/桌面/CAJ.desktop
                    echo "Icon=/opt/cajviewer/cajviewer.png" >> /root/桌面/CAJ.desktop
                    echo "StartupWMClass=CAJViewer" >> /root/桌面/CAJ.desktop
                    echo "Comment=CAJViewer" >> /root/桌面/CAJ.desktop
                    echo "Categories=Education" >> /root/桌面/CAJ.desktop
                    echo "Version=1.2" >> /root/桌面/CAJ.desktop
                    echo "StartupNotify=false" >> /root/桌面/CAJ.desktop
                    echo "X-KDE-Protocols=trust" >> /root/桌面/CAJ.desktop
                fi
            ;;
            8)
                echo "修改桌面分辨率"
                execute_4_1
            ;;
            9)
                echo "修改显示缩放倍率（即时生效）"
                execute_4_2
            ;;
            10)
                echo "清理安装过程中的错误"
                execute_4_3
            ;;
            11)
                echo "重置xfce桌面设置"
                execute_4_4
            ;;
            12)
                echo "下一步"
                execute_6_2
            ;;
            *)
                echo "未知选项"
            ;;
    esac
}


#检测/etc/ZR.conf内容是否为"1"，是则修复语言环境,先卸载wps-office再安装wps-office并修复wps-office窗口问题
if [ -f /etc/ZR.conf ]; then
    if [ "$(cat /etc/ZR.conf)" = "1" ]; then
        #修复语言环境
        sudo locale-gen zh_CN.UTF-8
        sudo update-locale LANG=zh_CN.UTF-8
        #删除ZR.conf文件
        rm -rf /etc/ZR.conf
        #卸载wps-office
        apt remove wps-office -y
        #安装wps-office
        apt install wps-office -y
        # 向usr/bin/wpp的第二行写入内容
            sed -i '2i\export QT_QPA_PLATFORMTHEME=qt5ct' /usr/bin/wpp
            sed -i '3i\export QT_SCALE_FACTOR=1' /usr/bin/wpp
            sed -i '4i\export QT_FONT_DPI=200' /usr/bin/wpp
            sed -i '5i\export QT_STYLE_OVERRIDE=kvantum' /usr/bin/wpp
            # 向usr/bin/wps的第二行写入内容
            sed -i '2i\export QT_QPA_PLATFORMTHEME=qt5ct' /usr/bin/wps
            sed -i '3i\export QT_SCALE_FACTOR=1' /usr/bin/wps
            sed -i '4i\export QT_FONT_DPI=200' /usr/bin/wps
            sed -i '5i\export QT_STYLE_OVERRIDE=kvantum' /usr/bin/wps
            # 向usr/bin/wpspdf的第二行写入内容
            sed -i '2i\export QT_QPA_PLATFORMTHEME=qt5ct' /usr/bin/wpspdf
            sed -i '3i\export QT_SCALE_FACTOR=1' /usr/bin/wpspdf
            sed -i '4i\export QT_FONT_DPI=200' /usr/bin/wpspdf
            sed -i '5i\export QT_STYLE_OVERRIDE=kvantum' /usr/bin/wpspdf
        #弹出确认窗口
        dialog --clear --backtitle "DaLongZhuaZi" --title "修复完成" --msgbox "ZeroRootfs环境修复完成，请重启容器" 10 35
        exit 0
    fi
fi

# 检测语言环境是否为中文，是则修改语言环境变量
if [ "$LANG" = "zh_CN.UTF-8" ]; then
    export LC_ALL=zh_CN.UTF-8
    export LANG=zh_CN.UTF-8
    export LANGUAGE=zh_CN.UTF-8
fi

main_menu() {
    if [ "$UPDATE" = true ]; then
        dialog --title "更新提示（更新后输入DLZZ来启动工具）" --yesno "$info" 10 70
        if [ $? -eq 0 ]; then
            rm -rf /root/IOAOSP
            mv -f /root/tmp/IOAOSP /root
            UPDATE=false
            exit 0
        fi
    else
        # 比较本地版本信息与脚本中的版本信息，如果不一致则UPDATE为“有新版本”
        if [ "$VERSION" != "$online_version" ]; then
            update_info="😉工具有新版本"
        else
            update_info="😄工具已是最新版本"
        fi
        
        CHOICE=$(dialog --clear --backtitle "安卓鸿蒙补完计划 by DaLongZhuaZi" \
            --title "DLZZ工具 v$VERSION" \
            --menu "请选择功能:" 15 45 9 \
            1 "📦安装软件与修复" \
            2 "🛠️系统功能" \
            3 "🔄更新本工具" \
            4 "📃常见问题"\
            5 "⚙️初始化工具（仅需执行一次）" \
            6 "🔗恢复包等资源链接"\
            7 "$update_info"\
            8 "💻当前恢复包版本：$ZT_VERSION"\
            9 "❌退出" \
        3>&1 1>&2 2>&3)
    
        case $CHOICE in
            1)
                echo "安装软件与修复"
                execute_option_1
            ;;
            2)
                echo "系统功能"
                execute_option_4
                ;;
            3)
                echo "更新本工具"
                execute_option_2
            ;;
            4)
                echo "常见问题"
                echo "正在安装所需依赖"
                if [ ! -f /usr/local/bin/mdless ]; then
                    apt install ruby-dev ruby-rubygems -y
                    gem install mdless
                fi
                echo "依赖安装完成"
                execute_option_6
            ;;
            5)
                echo "初始化工具（仅需执行一次）"
                execute_option_3
            ;;
            6)
                echo "恢复包等资源链接"
                execute_option_5
            ;;
            7)
                # 若有新版本则弹出更新提示，否则弹出版本信息
                if [ "$update_info" = "😉工具有新版本" ]; then
                    dialog --clear --backtitle "DaLongZhuaZi" --title "更新提示" --msgbox "有新版本，请按回车来更新" 10 35
                    execute_option_2
                else
                    dialog --clear --backtitle "DaLongZhuaZi" --title "更新内容" --msgbox "$change" 10 60
                fi
            ;;
            8)
                # 用neofetch显示系统信息，并退出脚本
                neofetch
                exit 0
            ;;
            9)
                echo "退出"
                exit 0
            ;;
            *)
                echo "未知选项"
            ;;
        esac
    fi
}

execute_option_1() {
    CHOICE=$(dialog --clear --backtitle "DaLongZhuaZi" \
        --title "可安装的软件列表" \
        --menu "请选择软件:" 15 60 16 \
        1 "🧰升级系统所有软件" \
        2 "📜安装WPS Office" \
        3 "📜WPS缩放修复" \
        4 "📜WPS字体补全" \
        5 "📱安装微信Beta版" \
        6 "📱修复微信快捷方式" \
        7 "🐧安装QQ"\
        8 "🐧修复QQ快捷方式"\
        9 "💹安装钉钉" \
        10 "🛍️安装星火应用商店终端版" \
        11 "⌨安装fcitx云拼音模块" \
        12 "🎓安装CAJ Viewer 1.2"\
        13 "🔌安装conky（桌面插件）"\
        14 "启动tmoe工具箱"\
        15 "⌨️安装华宇拼音输入法"\
        16 "返回主界面" \
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
            echo "WPS缩放修复"
            execute_1_3
        ;;
        4)
            echo "WPS字体补全"
            execute_1_4
        ;;
        5)
            echo "安装微信Beta版"
            execute_1_5
        ;;
        6)
            echo "修复微信快捷方式(多版本)"
            execute_1_6
        ;;
        7)
            echo "安装QQ"
            execute_1_12
        ;;
        8)
            echo "修复QQ快捷方式"
            execute_1_13
        ;;
        9)
            echo "安装钉钉"
            execute_1_7
        ;;
        10)
            echo "安装星火应用商店终端版"
            execute_1_8
        ;;
        11)
            echo "安装fcitx云拼音模块"
            execute_1_9
        ;;
        12)
            echo "安装CAJ Viewer"
            execute_1_10
        ;;
        13)
            echo "安装conky（桌面插件）"
            execute_1_11
        ;;
        14)
            echo "启动tmoe工具箱"
            curl -LO https://gitee.com/mo2/linux/raw/2/2.awk; awk -f 2.awk
        ;;
        15)
            echo "安装华宇拼音输入法"
            execute_1_14
        ;;
        16)
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
    dialog --clear --backtitle "DaLongZhuaZi" --title "更新完成" --msgbox "更新软件包完成，请按回车返回主界面" 10 35
}

execute_1_2() {
    # 在这里添加子操作1-2的代码
    apt update
    apt install wps-office wps-office-fonts -y
    # 向usr/bin/wpp的第二行写入内容
    sed -i '2i\export QT_QPA_PLATFORMTHEME=qt5ct' /usr/bin/wpp
    sed -i '3i\export QT_SCALE_FACTOR=1' /usr/bin/wpp
    sed -i '4i\export QT_FONT_DPI=200' /usr/bin/wpp
    sed -i '5i\export QT_STYLE_OVERRIDE=kvantum' /usr/bin/wpp
    # 向usr/bin/wps的第二行写入内容
    sed -i '2i\export QT_QPA_PLATFORMTHEME=qt5ct' /usr/bin/wps
    sed -i '3i\export QT_SCALE_FACTOR=1' /usr/bin/wps
    sed -i '4i\export QT_FONT_DPI=200' /usr/bin/wps
    sed -i '5i\export QT_STYLE_OVERRIDE=kvantum' /usr/bin/wps
    # 向usr/bin/wpspdf的第二行写入内容
    sed -i '2i\export QT_QPA_PLATFORMTHEME=qt5ct' /usr/bin/wpspdf
    sed -i '3i\export QT_SCALE_FACTOR=1' /usr/bin/wpspdf
    sed -i '4i\export QT_FONT_DPI=200' /usr/bin/wpspdf
    sed -i '5i\export QT_STYLE_OVERRIDE=kvantum' /usr/bin/wpspdf
    # 弹出确认窗口
    dialog --clear --backtitle "DaLongZhuaZi" --title "安装完成" --msgbox "WPS安装完成，请按回车返回主界面" 10 35
}

execute_1_3() {
    # 向usr/bin/wpp的第二行写入内容
    sed -i '2i\export QT_QPA_PLATFORMTHEME=qt5ct' /usr/bin/wpp
    sed -i '3i\export QT_SCALE_FACTOR=1' /usr/bin/wpp
    sed -i '4i\export QT_FONT_DPI=200' /usr/bin/wpp
    sed -i '5i\export QT_STYLE_OVERRIDE=kvantum' /usr/bin/wpp
    # 向usr/bin/wps的第二行写入内容
    sed -i '2i\export QT_QPA_PLATFORMTHEME=qt5ct' /usr/bin/wps
    sed -i '3i\export QT_SCALE_FACTOR=1' /usr/bin/wps
    sed -i '4i\export QT_FONT_DPI=200' /usr/bin/wps
    sed -i '5i\export QT_STYLE_OVERRIDE=kvantum' /usr/bin/wps
    # 向usr/bin/wpspdf的第二行写入内容
    sed -i '2i\export QT_QPA_PLATFORMTHEME=qt5ct' /usr/bin/wpspdf
    sed -i '3i\export QT_SCALE_FACTOR=1' /usr/bin/wpspdf
    sed -i '4i\export QT_FONT_DPI=200' /usr/bin/wpspdf
    sed -i '5i\export QT_STYLE_OVERRIDE=kvantum' /usr/bin/wpspdf
    # 弹出确认窗口
    dialog --clear --backtitle "DaLongZhuaZi" --title "修复完成" --msgbox "WPS修复完成，登录WPS之前请点击“外观”设置，修改窗口缩放为“1倍”，登录二维码即可正常显示，登录完成后再重新设置为“2倍”缩放。请按回车返回主界面" 10 55
}

execute_1_4() {
    # 在这里添加子操作1-4的代码
    # 从/root/sd移动到/root目录
    mv /root/sd/wps-fonts.tar.gz /root/
    # 解压wps-fonts.tar.gz并移动到指定目录
    tar -xzvf wps-fonts.tar.gz -C /usr/share/fonts/wps-office/
    # 删除
    rm -rf wps-fonts.tar.gz
    # 弹出确认窗口
    dialog --clear --backtitle "DaLongZhuaZi" --title "安装完成" --msgbox "WPS字体补全完成，请按回车返回主界面" 10 35
}

execute_1_5() {
    # 在这里添加子操作1-5的代码
    echo "开始下载"
    sudo wget -O wechat-beta_1.0.0.150_arm64.deb https://cdn4.cnxclm.com/uploads/2024/03/05/NKX87bHT_wechat-beta_1.0.0.150_arm64.deb
    echo "开始安装"
    sudo dpkg -i wechat-beta_1.0.0.150_arm64.deb
    apt -f install -y
    rm -rf wechat-beta_1.0.0.150_arm64.deb
    # 修补微信运行环境
    git clone https://aur.archlinux.org/wechat-uos.git
    cd wechat-uos
    #解压
    tar -xzvf license.tar.gz
    #复制并覆盖文件
    cp -rf license/etc/* /etc/
    cp -rf license/var/* /var/
    rm -rf /root/桌面/weixin.desktop
    # 重新创建微信桌面快捷方式
    echo "[Desktop Entry]" > /root/桌面/weixin.desktop
    echo "Name=微信" >> /root/桌面/weixin.desktop
    echo "Exec=env QT_QPA_PLATFORMTHEME=qt5ct QT_SCALE_FACTOR=1 QT_FONT_DPI=200 /opt/wechat-beta/wechat --no-sandbox" >> /root/桌面/weixin.desktop
    echo "Terminal=false" >> /root/桌面/weixin.desktop
    echo "Type=Application" >> /root/桌面/weixin.desktop
    echo "Icon=weixin" >> /root/桌面/weixin.desktop
    echo "StartupWMClass=微信" >> /root/桌面/weixin.desktop
    echo "Comment=微信桌面版" >> /root/桌面/weixin.desktop
    echo "Categories=Network" >> /root/桌面/weixin.desktop
    echo "Path=" >> /root/桌面/weixin.desktop
    echo "StartupNotify=false" >> /root/桌面/weixin.desktop
    echo "X-KDE-Protocols=trust" >> /root/桌面/weixin.desktop
    #删除文件
    cd ..
    rm -rf wechat-uos
    # 弹出确认窗口
    dialog --clear --backtitle "DaLongZhuaZi" --title "安装完成" --msgbox "微信Beta版安装完成，登录微信之前请点击“外观”设置，修改窗口缩放为“1倍”，登录二维码即可正常显示，请按回车返回主界面" 10 50
}

execute_1_6() {
    # 在这里添加子操作1-6的代码
    # 询问用户目前使用的是哪个微信版本，并根据用户选择进行不同的修复
    CHOICE=$(dialog --clear --backtitle "DaLongZhuaZi" \
        --title "微信版本选择" \
        --menu "请选择:" 15 40 4 \
        1 "微信Beta版" \
        2 "微信UOS版" \
        3 "v1.8恢复包内置版本"\
        4 "返回上一界面" \
    3>&1 1>&2 2>&3)
    
    case $CHOICE in
        1)
            echo "微信Beta版"
            execute_1_6_1
        ;;
        2)
            echo "微信UOS版"
            execute_1_6_2
        ;;
        3)
            echo "v1.8恢复包内置版本"
            execute_1_6_3
        ;;
        *)
            echo "未知选项"
        ;;
    esac
}

execute_1_6_1() {
    # 在这里添加子操作1-6-1的代码
    # 重新创建微信桌面快捷方式
    echo "[Desktop Entry]" > /root/桌面/weixin.desktop
    echo "Name=微信" >> /root/桌面/weixin.desktop
    echo "Exec=env QT_QPA_PLATFORMTHEME=qt5ct QT_SCALE_FACTOR=1 QT_FONT_DPI=200 /opt/wechat-beta/wechat --no-sandbox" >> /root/桌面/weixin.desktop
    echo "Terminal=false" >> /root/桌面/weixin.desktop
    echo "Type=Application" >> /root/桌面/weixin.desktop
    echo "Icon=weixin" >> /root/桌面/weixin.desktop
    echo "StartupWMClass=微信" >> /root/桌面/weixin.desktop
    echo "Comment=微信桌面版" >> /root/桌面/weixin.desktop
    echo "Categories=Network" >> /root/桌面/weixin.desktop
    echo "Path=" >> /root/桌面/weixin.desktop
    echo "StartupNotify=false" >> /root/桌面/weixin.desktop
    echo "X-KDE-Protocols=trust" >> /root/桌面/weixin.desktop
    # 弹出确认窗口
    dialog --clear --backtitle "DaLongZhuaZi" --title "修复完成" --msgbox "微信Beta版快捷方式修复完成，请按回车返回主界面" 10 35
}

execute_1_6_2() {
    # 在这里添加子操作1-6-2的代码
    # 删除微信快捷方式，重新创建
    rm -rf /root/桌面/weixin.desktop
    echo "[Desktop Entry]" > /root/桌面/weixin.desktop
    echo "Name=微信" >> /root/桌面/weixin.desktop
    echo "Exec=/opt/apps/com.tencent.weixin/files/weixin/weixin --no-sandbox" >> /root/桌面/weixin.desktop
    echo "Terminal=false" >> /root/桌面/weixin.desktop
    echo "Type=Application" >> /root/桌面/weixin.desktop
    echo "Icon=weixin" >> /root/桌面/weixin.desktop
    echo "StartupWMClass=微信" >> /root/桌面/weixin.desktop
    echo "Comment=微信桌面版" >> /root/桌面/weixin.desktop
    echo "Categories=Network" >> /root/桌面/weixin.desktop
    echo "Path=" >> /root/桌面/weixin.desktop
    echo "StartupNotify=false" >> /root/桌面/weixin.desktop
    echo "X-KDE-Protocols=trust" >> /root/桌面/weixin.desktop
    # 弹出确认窗口
    dialog --clear --backtitle "DaLongZhuaZi" --title "修复完成" --msgbox "微信UOS版快捷方式修复完成，请按回车返回主界面" 10 35
}

execute_1_6_3() {
    # 在这里添加子操作1-6-3的代码
    # 删除微信快捷方式，重新创建
    rm -rf /root/桌面/weixin.desktop
    echo "[Desktop Entry]" > /root/桌面/weixin.desktop
    echo "Name=微信" >> /root/桌面/weixin.desktop
    echo "Exec=/opt/apps/store.spark-app.wechat-linux-spark/files/files/weixin --no-sandbox" >> /root/桌面/weixin.desktop
    echo "Terminal=false" >> /root/桌面/weixin.desktop
    echo "Type=Application" >> /root/桌面/weixin.desktop
    echo "Icon=weixin" >> /root/桌面/weixin.desktop
    echo "StartupWMClass=微信" >> /root/桌面/weixin.desktop
    echo "Comment=微信桌面版" >> /root/桌面/weixin.desktop
    echo "Categories=Network" >> /root/桌面/weixin.desktop
    echo "Path=" >> /root/桌面/weixin.desktop
    echo "StartupNotify=false" >> /root/桌面/weixin.desktop
    echo "X-KDE-Protocols=trust" >> /root/桌面/weixin.desktop
    
    # 弹出确认窗口
    dialog --clear --backtitle "DaLongZhuaZi" --title "修复完成" --msgbox "微信快捷方式修复完成，请按回车返回主界面" 10 35
}

execute_1_7() {
    # 在这里添加子操作1-7的代码
    echo "开始下载"
    sudo wget -O com.alibabainc.dingtalk_7.5.10.404071_arm64.deb https://dtapp-pub.dingtalk.com/dingtalk-desktop/xc_dingtalk_update/linux_deb/Release/com.alibabainc.dingtalk_7.5.10.404071_arm64.deb
    echo "开始安装"
    sudo dpkg -i com.alibabainc.dingtalk_7.5.10.404071_arm64.deb
    apt update
    apt install libglut3.12 -y
    apt -f install -y
    rm -rf com.alibabainc.dingtalk_7.5.10.404071_arm64.deb
    # 添加钉钉桌面快捷方式
    echo "[Desktop Entry]" > /root/桌面/dingding.desktop
    echo "Name=钉钉" >> /root/桌面/dingding.desktop
    echo "Exec=/opt/apps/com.alibabainc.dingtalk/files/Elevator.sh" >> /root/桌面/dingding.desktop
    echo "Terminal=false" >> /root/桌面/dingding.desktop
    echo "Type=Application" >> /root/桌面/dingding.desktop
    echo "Icon=/opt/apps/com.alibabainc.dingtalk/files/logo.ico" >> /root/桌面/dingding.desktop
    echo "StartupWMClass=钉钉" >> /root/桌面/dingding.desktop
    echo "Comment=钉钉桌面版" >> /root/桌面/dingding.desktop
    echo "Categories=Network" >> /root/桌面/dingding.desktop
    echo "Path=" >> /root/桌面/dingding.desktop
    echo "StartupNotify=false" >> /root/桌面/dingding.desktop
    echo "X-KDE-Protocols=trust" >> /root/桌面/dingding.desktop
    # 弹出确认窗口
    dialog --clear --backtitle "DaLongZhuaZi" --title "安装完成" --msgbox "钉钉Linux安装完成，请按回车返回主界面" 10 35
}

execute_1_8() {
    # 在这里添加子操作1-8的代码
    echo "开始下载"
    sudo wget -O spark-store-console_4.2.12_all.deb https://gitee.com/spark-store-project/spark-store/releases/download/4.2.12/spark-store-console_4.2.12_all.deb
    echo "开始安装"
    sudo dpkg -i spark-store-console_4.2.12_all.deb
    apt -f install -y
    rm -rf spark-store-console_4.2.12_all.deb
    # 弹出确认窗口
    dialog --clear --backtitle "DaLongZhuaZi" --title "安装完成" --msgbox "星火应用商店终端版安装完成，请按回车返回主界面" 10 35
}

execute_1_9() {
    # 在这里添加子操作1-9的代码
    apt update
    apt install fcitx-cloudpinyin -y
    im-config -r
    # 弹出确认窗口
    dialog --clear --backtitle "DaLongZhuaZi" --title "安装完成" --msgbox "fcitx云拼音模块安装完成，请打开Fcitx配置页面，在“附加组件”选项卡中启用并配置云拼音模块" 10 45
}

execute_1_10() {
    # 在这里添加子操作1-10的代码
    echo "安装CAJ Viewer"
    #删除本地文件残留
    rm -rf /opt/apps/net.cnki.cajviewer/
    rm -rf /root/桌面/CAJ.desktop
    rm -rf /root/桌面/CAJ Viewer.desktop
    #获取1.2版本文件
    wget cajviewer_1.2.2-1_arm64.deb https://download.cnki.net/cajPackage/yinHeQiLing/cajviewer_1.2.2-1_arm64.deb
    dpkg -i cajviewer_1.2.2-1_arm64.deb
    rm -rf cajviewer_1.2.2-1_arm64.deb
    #启动脚本
    echo "#!/bin/bash" > /opt/cajviewer/bin/start.sh
    echo "export QT_SCALE_FACTOR=1" >> /opt/cajviewer/bin/start.sh
    echo "export QT_FONT_DPI=200" >> /opt/cajviewer/bin/start.sh
    echo "export QT_STYLE_OVERRIDE=kvantum" >> /opt/cajviewer/bin/start.sh
    echo "export LD_LIBRARY_PATH=/opt/cajviewer/lib:$LD_LIBRARY_PATH" >> /opt/cajviewer/bin/start.sh
    echo "/opt/cajviewer/bin/cajviewer" >> /opt/cajviewer/bin/start.sh
    chmod +x /opt/cajviewer/bin/start.sh
    #快捷方式
    echo "[Desktop Entry]" > /root/桌面/CAJ.desktop
    echo "Name=CAJViewer" >> /root/桌面/CAJ.desktop
    echo "Exec=/opt/cajviewer/bin/start.sh" >> /root/桌面/CAJ.desktop
    echo "Terminal=false" >> /root/桌面/CAJ.desktop
    echo "Type=Application" >> /root/桌面/CAJ.desktop
    echo "Icon=/opt/cajviewer/cajviewer.png" >> /root/桌面/CAJ.desktop
    echo "StartupWMClass=CAJViewer" >> /root/桌面/CAJ.desktop
    echo "Comment=CAJViewer" >> /root/桌面/CAJ.desktop
    echo "Categories=Education" >> /root/桌面/CAJ.desktop
    echo "Version=1.2" >> /root/桌面/CAJ.desktop
    echo "StartupNotify=false" >> /root/桌面/CAJ.desktop
    echo "X-KDE-Protocols=trust" >> /root/桌面/CAJ.desktop
    # 弹出确认窗口
    dialog --clear --backtitle "DaLongZhuaZi" --title "安装完成" --msgbox "CAJ Viewer 1.2安装完成，请按回车返回主界面" 10 35
}

execute_1_11() {
    # 安装conky
    apt update
    apt install conky -y
    # 创建conky启动快捷方式
    echo "[Desktop Entry]" > /root/桌面/conky.desktop
    echo "Name=conky" >> /root/桌面/conky.desktop
    echo "Exec=conky" >> /root/桌面/conky.desktop
    echo "Terminal=false" >> /root/桌面/conky.desktop
    echo "Type=Application" >> /root/桌面/conky.desktop
    echo "Icon=conky" >> /root/桌面/conky.desktop
    echo "StartupWMClass=conky" >> /root/桌面/conky.desktop
    echo "Comment=conky桌面插件" >> /root/桌面/conky.desktop
    echo "Categories=System" >> /root/桌面/conky.desktop
    echo "Path=" >> /root/桌面/conky.desktop
    echo "StartupNotify=false" >> /root/桌面/conky.desktop
    echo "X-KDE-Protocols=trust" >> /root/桌面/conky.desktop
    # 启动conky
    conky
    # 弹出确认窗口
    dialog --clear --backtitle "DaLongZhuaZi" --title "安装完成" --msgbox "conky安装与启动，后续启动请点击桌面快捷方式。按回车返回主界面" 10 40
}

execute_1_12() {
    # 在这里添加子操作1-12的代码
    apt update
    apt install linuxqq -y
    # 添加QQ桌面快捷方式
    echo "[Desktop Entry]" > /root/桌面/QQ.desktop
    echo "Name=QQ" >> /root/桌面/QQ.desktop
    echo "Exec=/opt/QQ/qq --no-sandbox %U" >> /root/桌面/QQ.desktop
    echo "Terminal=false" >> /root/桌面/QQ.desktop
    echo "Type=Application" >> /root/桌面/QQ.desktop
    echo "Icon=QQ" >> /root/桌面/QQ.desktop
    echo "StartupWMClass=QQ" >> /root/桌面/QQ.desktop
    echo "Comment=QQ" >> /root/桌面/QQ.desktop
    echo "Categories=Network" >> /root/桌面/QQ.desktop
    echo "StartupNotify=false" >> /root/桌面/QQ.desktop
    echo "X-KDE-Protocols=trust" >> /root/桌面/QQ.desktop
    # 弹出确认窗口
    dialog --clear --backtitle "DaLongZhuaZi" --title "安装完成" --msgbox "QQ安装完成，请按回车返回主界面" 10 35
}

execute_1_13() {
    # 在这里添加子操作1-13的代码
    # 添加QQ桌面快捷方式
    echo "[Desktop Entry]" > /root/桌面/QQ.desktop
    echo "Name=QQ" >> /root/桌面/QQ.desktop
    echo "Exec=/opt/QQ/qq --no-sandbox %U" >> /root/桌面/QQ.desktop
    echo "Terminal=false" >> /root/桌面/QQ.desktop
    echo "Type=Application" >> /root/桌面/QQ.desktop
    echo "Icon=QQ" >> /root/桌面/QQ.desktop
    echo "StartupWMClass=QQ" >> /root/桌面/QQ.desktop
    echo "Comment=QQ" >> /root/桌面/QQ.desktop
    echo "Categories=Network" >> /root/桌面/QQ.desktop
    echo "StartupNotify=false" >> /root/桌面/QQ.desktop
    echo "X-KDE-Protocols=trust" >> /root/桌面/QQ.desktop
    # 弹出确认窗口
    dialog --clear --backtitle "DaLongZhuaZi" --title "修复完成" --msgbox "QQ快捷方式修复完成，请按回车返回主界面" 10 35
}

execute_1_14() {
    # 在这里添加子操作1-14的代码
    # 安装华宇拼音输入法
    # 询问用户是否需要卸载其他输入法
    CHOICE=$(dialog --clear --backtitle "DaLongZhuaZi" \
        --title "华宇拼音输入法" \
        --menu "是否需要卸载其他输入法:" 15 40 3 \
        1 "是" \
        2 "否" \
    3>&1 1>&2 2>&3)
    
    case $CHOICE in
        1)
            echo "卸载其他输入法"
            apt remove --purge fcitx-googlepinyin fcitx-sunpinyin fcitx-libpinyin fcitx-rime -y
            wget -O HuayuPY_uos_arm_fcitx_2.4.8.207.deb "https://pinyin.thunisoft.com/webapi/v1/downloadSetupFile?os=uos&cpu=arm"
            dpkg -i HuayuPY_uos_arm_fcitx_2.4.8.207.deb
            apt -f install -y
            rm -rf HuayuPY_uos_arm_fcitx_2.4.8.207.deb
        ;;
        2)
            echo "不卸载其他输入法"
            wget -O HuayuPY_uos_arm_fcitx_2.4.8.207.deb "https://pinyin.thunisoft.com/webapi/v1/downloadSetupFile?os=uos&cpu=arm"
            dpkg -i HuayuPY_uos_arm_fcitx_2.4.8.207.deb
            apt -f install -y
            rm -rf HuayuPY_uos_arm_fcitx_2.4.8.207.deb
        ;;
        *)
            echo "未知选项"
        ;;
    esac
    
    
    # 弹出确认窗口
    dialog --clear --backtitle "DaLongZhuaZi" --title "安装完成" --msgbox "华宇拼音输入法安装完成，请重新启动容器，华宇拼音输入法将自动启用，如未出现请右键点击小企鹅图标，选择“输入法”-“华宇输入法”" 10 60
}

execute_option_2() {
    # 更新工具
    sh /root/IOAOSP_update.sh
    # 弹出确认窗口
    dialog --clear --backtitle "DaLongZhuaZi" --title "更新完成" --msgbox "更新完成，请按回车退出脚本" 10 35
    # 重启脚本
    exit 0
}

execute_option_3() {
    # 初始化
    cat <<EOL >>/etc/zsh/zshrc

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
    dialog --clear --backtitle "DaLongZhuaZi" --title "初始化完成" --msgbox "请在退出工具后手动输入source /etc/zsh/zshrc并回车" 10 40
}

execute_option_4() {
    # 系统功能
    CHOICE=$(dialog --clear --backtitle "DaLongZhuaZi" \
        --title "系统功能" \
        --menu "请选择:" 15 60 6 \
        1 "💻修改桌面分辨率（ZeroRootfs专用）" \
        2 "💻修改桌面分辨率（使用VNC连接时有效）" \
        3 "🗔修改显示DPI（所有连接方式可用，及时生效）" \
        4 "❌清理安装过程中的错误" \
        5 "🔙重置xfce桌面设置" \
        6 "返回主界面" \
    3>&1 1>&2 2>&3)
    
    case $CHOICE in
        1)
            echo "修改桌面分辨率"
            execute_4_5
        ;;
        2)
            echo "修改桌面分辨率"
            execute_4_1
        ;;
        3)
            echo "修改显示缩放倍率（即时生效）"
            execute_4_2
        ;;
        4)
            echo "清理安装过程中的错误"
            execute_4_3
        ;;
        5)
            echo "重置xfce桌面设置"
            execute_4_4
        ;;
        6)
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
    dialog --clear --backtitle "DaLongZhuaZi" --title "设置完成" --msgbox "分辨率设置完成，请输入restartvnc来重启vnc服务，按回车返回主界面" 10 40
}

execute_4_2() {
    # 使用 dialog 创建输入框，确保输入有效的缩放倍率
    scale=$(dialog --inputbox "请输入新的缩放倍率，仅支持整数倍:" 10 30 --stdout --no-cancel)
    # 修改xfconf配置文件中的缩放倍率
    xfconf-query -c xsettings -p /Xft/DPI -s $((96 * $scale))
    # 弹出确认窗口
    dialog --clear --backtitle "DaLongZhuaZi" --title "设置完成" --msgbox "缩放倍率设置完成，已即时生效，部分软件显示可能不正常，按回车返回主界面" 10 40
}

execute_4_3() {
    # 清理安装过程中的错误
    apt -f install -y
    # 修复dpkg
    dpkg --configure -a
    # 清理apt
    apt clean
    apt autoclean
    apt autoremove
    # 弹出确认窗口
    dialog --clear --backtitle "DaLongZhuaZi" --title "清理完成" --msgbox "清理完成，请按回车返回主界面" 10 35
}

execute_4_4() {
    # 再次确认是否重置
    dialog --clear --backtitle "DaLongZhuaZi" --title "重置确认" --yesno "重置xfce桌面设置将会删除所有桌面设置，是否继续？" 10 35
    # 获取上一个命令的退出状态码
    response=$?
    case $response in
        0)
            echo "重置xfce桌面设置"
        ;;
        1)
            echo "取消重置"
            return
        ;;
        *)
            echo "未知选项"
        ;;
    esac
    # 重置xfce桌面设置
    xfce4-panel --quit
    pkill xfconfd
    rm -rf /root/.config/xfce4
    # 弹出确认窗口
    dialog --clear --backtitle "DaLongZhuaZi" --title "重置完成" --msgbox "重置完成，请重启容器以应用更改，按回车返回主界面" 10 35
}

execute_4_5() {
    # 弹出提示窗口
    dialog --clear --backtitle "DaLongZhuaZi" --title "分辨率设置" --msgbox "请在ZeroRootfs中使用此功能，分辨率设置完成后会自动重启VNC服务" 10 40
    execute_4_6
}
execute_4_6() {
    # 使用 dialog 创建输入框，确保输入有效的分辨率格式
    resolution=$(dialog --inputbox "请输入新的分辨率，例如:2880x1440（中间为小写字母x）:" 10 30 --stdout --no-cancel)
    # 在文件中替换第 17 行的内容为用户输入的分辨率
    sed -i "17s/.*/VNC_RESOLUTION=$resolution/" /usr/local/bin/startvnc
    # 自动重启vnc服务
    stopvnc
    startvnc
}


execute_option_5() {
    # 恢复包等资源链接
    CHOICE=$(dialog --clear --backtitle "DaLongZhuaZi" \
        --title "恢复包等资源链接" \
        --menu "请选择:" 15 40 5 \
        1 "📁恢复包" \
        2 "🤖Android软件" \
        3 "🐧Linux软件"\
        4 "ZR相关内容"\
        5 "返回主界面" \
    3>&1 1>&2 2>&3)
    
    case $CHOICE in
        1)
            echo "恢复包"
            execute_5_1
        ;;
        2)
            echo "Android软件"
            execute_5_2
        ;;
        3)
            echo "Linux软件"
            execute_5_3
        ;;
        4)
            echo "ZR相关内容"
            execute_5_4
        ;;
        5)
            echo "返回主界面"
        ;;
        *)
            echo "未知选项"
        ;;
    esac
}

execute_5_1() {
    # 选择恢复包版本
    CHOICE=$(dialog --clear --backtitle "DaLongZhuaZi" \
        --title "恢复包版本选择（更早版本请在酷安@大龙爪子021）" \
        --menu "请选择:" 15 50 5 \
        1 "v1.9" \
        2 "v1.8" \
        3 "v1.7" \
        4 "v1.6" \
        5 "v1.5" \
        6 "返回上一界面" \
    3>&1 1>&2 2>&3)
    
    case $CHOICE in
        1)
            echo "v1.9"
            execute_5_1_5
        ;;
        2)
            echo "v1.8"
            execute_5_1_1
        ;;
        3)
            echo "v1.7"
            execute_5_1_2
        ;;
        4)
            echo "v1.6"
            execute_5_1_3
        ;;
        5)
            echo "v1.5"
            execute_5_1_4
        ;;
        6)
            echo "返回上一界面"
        ;;
        *)
            echo "未知选项"
        ;;
    esac
}

execute_5_1_1(){
    # 恢复包v1.8
    # 弹出确认窗口
    dialog --clear --backtitle "DaLongZhuaZi" --title "恢复包v1.8" --msgbox "https://www.123pan.com/s/3VQ8Vv-5krBH.html" 10 45
}

execute_5_1_2(){
    # 恢复包v1.7
    # 弹出确认窗口
    dialog --clear --backtitle "DaLongZhuaZi" --title "恢复包v1.7" --msgbox "https://www.123pan.com/s/3VQ8Vv-PcDBH.html" 10 45
}

execute_5_1_3(){
    # 恢复包v1.6
    # 弹出确认窗口
    dialog --clear --backtitle "DaLongZhuaZi" --title "恢复包v1.6" --msgbox "https://www.123pan.com/s/3VQ8Vv-1UDBH.html" 10 45
}

execute_5_1_4(){
    # 恢复包v1.5
    # 弹出确认窗口
    dialog --clear --backtitle "DaLongZhuaZi" --title "恢复包v1.5" --msgbox "https://www.123pan.com/s/3VQ8Vv-P0DBH.html" 10 45
}

execute_5_1_5(){
    # 恢复包v1.9
    # 弹出确认窗口
    dialog --clear --backtitle "DaLongZhuaZi" --title "恢复包v1.9 & 1.9lite" --msgbox "https://www.123pan.com/s/3VQ8Vv-1z8BH.html  &  https://www.123pan.com/s/3VQ8Vv-4z8BH.html" 10 45
}

execute_5_2() {
    # 选择Android软件
    CHOICE=$(dialog --clear --backtitle "DaLongZhuaZi" \
        --title "Android软件" \
        --menu "请选择:" 15 60 4 \
        1 "ZeroTermux-0.118.37等三件套" \
        2 "KDEConnect" \
        3 "VNC Viewer" \
        4 "返回上一界面" \
    3>&1 1>&2 2>&3)
    
    case $CHOICE in
        1)
            echo "ZeroTermux-0.118.37等三件套"
            execute_5_2_1
        ;;
        2)
            echo "KDEConnect"
            execute_5_2_2
        ;;
        3)
            echo "VNC Viewer"
            execute_5_2_3
        ;;
        4)
            echo "返回上一界面"
        ;;
        *)
            echo "未知选项"
        ;;
    esac
}

execute_5_2_1(){
    # ZeroTermux-0.118.37等三件套
    # 弹出确认窗口
    dialog --clear --backtitle "DaLongZhuaZi" --title "ZeroTermux-0.118.37等三件套" --msgbox "https://www.123pan.com/s/3VQ8Vv-YA8BH.html" 10 45
}

execute_5_2_2(){
    # KDEConnect
    # 弹出确认窗口
    dialog --clear --backtitle "DaLongZhuaZi" --title "KDEConnect" --msgbox "https://www.123pan.com/s/3VQ8Vv-XcDBH.html" 10 45
}

execute_5_2_3(){
    # VNC Viewer
    # 弹出确认窗口
    dialog --clear --backtitle "DaLongZhuaZi" --title "VNC Viewer" --msgbox "https://www.123pan.com/s/3VQ8Vv-W08BH.html" 10 45
}

execute_5_3() {
    # 选择Linux软件
    CHOICE=$(dialog --clear --backtitle "DaLongZhuaZi" \
        --title "Linux软件" \
        --menu "请选择:" 15 40 3 \
        1 "CAJViewer" \
        2 "WPS字体补全" \
        3 "返回主界面" \
    3>&1 1>&2 2>&3)
    
    case $CHOICE in
        1)
            echo "CAJViewer"
            execute_5_3_1
        ;;
        2)
            echo "WPS字体补全"
            execute_5_3_2
        ;;
        3)
            echo "返回上一界面"
        ;;
        *)
            echo "未知选项"
        ;;
    esac
}

execute_5_3_1(){
    # CAJViewer
    # 弹出确认窗口
    dialog --clear --backtitle "DaLongZhuaZi" --title "CAJViewer" --msgbox "https://www.123pan.com/s/3VQ8Vv-gKDBH.html" 10 45
}

execute_5_3_2(){
    # WPS字体补全
    # 弹出确认窗口
    dialog --clear --backtitle "DaLongZhuaZi" --title "WPS字体补全" --msgbox "https://www.123pan.com/s/3VQ8Vv-N08BH.html" 10 45
}

execute_5_4() {
    # ZR相关内容
    # 选择ZR相关内容
    CHOICE=$(dialog --clear --backtitle "DaLongZhuaZi" \
        --title "ZR相关内容" \
        --menu "请选择:" 15 40 3 \
        1 "ZR相关内容" \
        2 "ZR相关内容" \
        3 "返回主界面" \
    3>&1 1>&2 2>&3)
    
    case $CHOICE in
        1)
            echo "ZR相关内容"
            execute_5_4_1
        ;;
        2)
            echo "ZR相关内容"
            execute_5_4_2
        ;;
        3)
            echo "返回上一界面"
        ;;
        *)
            echo "未知选项"
        ;;
    esac
}

execute_option_6() {
    CHOICE=$(dialog --clear --backtitle "DaLongZhuaZi" \
        --title "常见问题" \
        --menu "按↑↓来滑动查看，输入q来退出:" 15 60 6 \
        1 "画面问题" \
        2 "声音问题" \
        3 "容器内软件问题" \
        4 "TermuxX11教程" \
        5 "共享文件夹" \
        6 "返回主界面" \
    3>&1 1>&2 2>&3)
    
    case $CHOICE in
        1)
            echo "画面问题"
            mdless /root/IOAOSP/tips/signal9.md
        ;;
        2)
            echo "声音问题"
            mdless /root/IOAOSP/tips/audio.md
        ;;
        3)
            echo "容器内软件问题"
            mdless /root/IOAOSP/tips/app.md
        ;;
        4)
            echo "TermuxX11教程"
            mdless /root/IOAOSP/tips/termuxx11.md
        ;;
        5)
            echo "共享文件夹"
            mdless /root/IOAOSP/tips/share.md
        ;;
        6)
            echo "返回上一界面"
        ;;
        *)
            echo "未知选项"
        ;;
    esac
}

# 检测ZT_NEW是否为true，是则运行初始化操作
if [ "$ZT_NEW" = "true" ]; then
    while true; do
        execute_6
    done
fi
# 运行主选择界面
while true; do
    main_menu
done
