# 软件问题
1. 软件可使用星火应用商店终端版进行安装，输入```spark-store-console```来启动商店
2. 如果有Linux使用经验的话可以使用```apt```等工具进行在线安装，内置的多个软件源覆盖了绝大多数国内Linux生态软件
> ## apt 常用命令  
> + 列出所有可更新的软件清单命令：```sudo apt update```
> + 升级软件包：```sudo apt upgrade```  
> + 列出可更新的软件包及版本信息：```apt list --upgradeable```  
> + 升级软件包，升级前先删除需要更新软件包：```sudo apt full-upgrade```  
> + 安装指定的软件命令：```sudo apt install <package_name>```  
> + 安装多个软件包：```sudo apt install <package_1> <package_2> <package_3>```  
> + 更新指定的软件命令：```sudo apt update <package_name>```  
> + 显示软件包具体信息,例如：版本号，安装大小，依赖关系等等：```sudo apt show <package_name>```  
> + 删除软件包命令：```sudo apt remove <package_name>```  
> + 清理不再使用的依赖和库文件: ```sudo apt autoremove```  
> + 移除软件包及配置文件: ```sudo apt purge <package_name>```  
> + 查找软件包命令： ```sudo apt search <keyword>```  
> + 列出所有已安装的包：```apt list --installed```  
> + 列出所有已安装的包的版本信息：```apt list --all-versions```  

3. 下载安装包本地安装时，请选择下载```arm64/aarch64```架构的```deb```格式安装包，下载完成后双击即可安装，dpkg会自动安装相关依赖（但有些时候并不会）
4. 本地安装的软件可能会没有桌面快捷方式，这个时候可以在开始菜单里面找，或者去/opt以及/opt/apps文件夹下查找，找到之后再添加桌面快捷方式
5. 如果出现软件打不开，请先尝试在软件快捷方式的命令里面添加```--no-sandbox --unity-launch```，如果还是不行，那多半是依赖问题了，解决起来相当麻烦
6. 关于软件的各种疑难杂症请善用搜索引擎或者先问问GPT，这类问题如果没用过对应软件的话还真不知道