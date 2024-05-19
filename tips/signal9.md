# “没有画面”“断连”“字太小”等问题的解决办法
首先请检查软件的权限设置，比如读取、悬浮窗、显示在其他应用上层等权限，并在TermuxX11运行时，把ZeroTermux以小窗、分屏等形式挂在前台

## 一.Signal 9相关问题

受安卓系统限制，可能会出现使用几分钟到十几分钟后黑屏、断连的现象，此时一般Termux会报错“Signal 9”

解决办法：

###  如果你的设备有root  
+ 请彻底关闭ZeroTermux，再重新打开  
+ 输入“adb”来查看是否已经安卓Android tools，如果没有打印出adb的相关内容，请输入“apt install android-tools -y”  
+ 输入 su来获取root权限
+ 然后再根据系统版本输入以下内容
+ 最后重启设备  

### Android 12L和Android 13、14：

```su -c "settings put global settings_enable_monitor_phantom_procs false"```
### Android12及以下：

```su -c "/system/bin/device_config set_sync_disabled_for_tests persistent; /system/bin/device_config put activity_manager max_phantom_processes 2147483647"```


 

### 如果你的设备没有root
+ 请选择无线/有线adb工具连接设备，比如晨钟工具箱，甲壳虫ADB助手等等
+ 然后根据系统版本输入以下内容（根据工具不同，有时需要去掉“./”）
+ 最后重启设备  

### Android 12L和Android 13、14：

```./adb shell "settings put global settings_enable_monitor_phantom_procs false"```
### Android 12及以下：

```./adb shell "/system/bin/device_config set_sync_disabled_for_tests persistent; /system/bin/device_config put activity_manager max_phantom_processes 2147483647"  ```

## 二，无法连接对应窗口的问题

> 如果是华为、小米设备且使用过系统的PC应用引擎，请先尝试冻结或者卸载系统的PC应用引擎及相关软件，具体原因请看下面的图文
<https://www.coolapk.com/feed/54009318?shareKey=ZjRjOWE1ZDFmZDc3NjYzY2RkYzk~&shareUid=1882067&shareFrom=com.coolapk.market_14.1.2>

> 如果不是这两个品牌的设备或者没有使用过PC应用引擎，在排除了Signal 9之后还是出现无法连接的问题，请采用下面教程中的方法
<https://www.coolapk.com/feed/48650726?shareKey=NWIyYTYwZjM1Y2IwNjRmZGQ2YzA~&shareUid=1882067&shareFrom=com.coolapk.market_13.3.4-beta1>

## 三，桌面环境显示问题
+ 默认的连接方式（TermuxX11）会自适应屏幕分辨率大小，无需调整  
+ 全局的缩放可以在```设置-外观-窗口缩放```进行倍率调整，或者通过DLZZ工具内的```系统功能-修改显示DPI```进行无极调节
+ WPS、微信的缩放问题可通过DLZZ工具进行修复，选择工具内的```安装软件与修复```功能即可看到对应选项
+ 其他软件的缩放问题可以尝试在软件快捷方式的启动命令里面添加```env QT_QPA_PLATFORMTHEME=qt5ct QT_SCALE_FACTOR=1 QT_FONT_DPI=200```