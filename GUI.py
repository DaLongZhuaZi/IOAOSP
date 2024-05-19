

import tkinter as tk
from tkinter import Menu, messagebox, filedialog, font, simpledialog
from functools import partial
import subprocess
import os
import colorsys  # colorsys模块用于颜色空间转换

# 生成彩虹颜色的函数
def generate_rainbow_colors(num_colors):
    colors = []
    # 彩虹的基本颜色（HSV表示）
    rainbow_hsv = [
        (0/5, 0.8, 1.0),  # 红色
        (1/5, 0.8, 1.0),  # 橙色
        (2/5, 0.8, 1.0),  # 黄色
        (3/5, 0.8, 1.0),  # 绿色
        (4/5, 0.8, 1.0),  # 青色
        (5/5, 0.8, 1.0),  # 蓝色
        (6/5, 0.8, 1.0)   # 紫色
    ]
    
    # 计算颜色间隔
    step = 1 / (num_colors - 1)
    
    for i in range(num_colors):
        # 计算当前颜色的HSV值
        hue = i * step
        while hue >= 1:
            hue -= 1
        hsv = rainbow_hsv[int(hue * 5)]
        
        # 将HSV转换为RGB
        rgb = colorsys.hsv_to_rgb(*hsv)
        # 将RGB转换为十六进制
        hex_color = '#{:02x}{:02x}{:02x}'.format(int(rgb[0] * 255), int(rgb[1] * 255), int(rgb[2] * 255))
        colors.append(hex_color)
    
    return colors

def about():
    messagebox.showinfo("关于", "快写好了。")

def execute_command(command):
    try:
        subprocess.run(command, shell=True, check=True)
    except subprocess.CalledProcessError as e:
        messagebox.showerror("错误", f"执行命令时出错: {e}")

def open_file_dialog():
    file_path = filedialog.askopenfilename()
    messagebox.showinfo("文件打开", f"你选择的文件是: {file_path}")

def open_save_dialog():
    file_path = filedialog.asksaveasfilename()
    messagebox.showinfo("文件保存", f"你选择保存的文件是: {file_path}")


# 生成25种彩虹颜色
colors = generate_rainbow_colors(25)


# 为子窗口按钮添加功能的示例
def button_function(command):
    def inner():
        try:
            subprocess.run(command, shell=True, check=True)
        except subprocess.CalledProcessError as e:
            messagebox.showerror("错误", f"执行命令时出错: {e}")
    return inner

# 更新 create_sub_window_parts 函数以确保每个按钮都有独特的颜色
def create_sub_window_parts(sub_menu, part_texts, commands):
    # 固定子窗口大小
    button_width = 400
    button_height = 200
    num_columns = 5
    sub_menu_width = num_columns * button_width
    sub_menu_height = num_columns * button_height  # 5列，确保高度能容纳25个按钮

    sub_menu.geometry(f"{sub_menu_width}x{sub_menu_height}")

    # 生成足够的彩虹颜色供25个按钮使用
    colors = generate_rainbow_colors(25)
    
    for i, command in enumerate(commands):
        # 直接使用按钮索引 i 作为颜色列表的索引，确保每个按钮颜色都不同
        button_color = colors[i]
        text = part_texts[i % len(part_texts)] if part_texts else f"按钮 {i + 1}"
        button = tk.Button(sub_menu, text=text, bg=button_color, fg="black", font=second_font, command=partial(execute_command, command))
        row = i // num_columns
        col = i % num_columns
        button.place(relx=col * (1 / num_columns), rely=row * (1 / num_columns),
                     relwidth=(1 / num_columns), relheight=(1 / num_columns))

# 辅助函数，用于按钮点击事件
def on_button_click(part_number):
    # 定义每个子菜单的按钮命令和文本
    sub_part_data = {
        1: {
            'commands': ["apt update&&apt upgrade -y", 
                         "echo 命令2", 
                         "echo 命令3", 
                         "echo 命令4", 
                         "echo 命令5",
                         "a",
                         "a",
                         "a",
                         "a",
                         "a",
                         "a",
                         "a",
                         "a",
                         "a",
                         "a"],
            'texts': ["🧰升级系统所有软件", 
                      "📜安装WPS Office", 
                      "📜WPS缩放修复", 
                      "📜WPS字体补全", 
                      "📱安装微信\nBeta版",
                      "📱修复微信快捷\n方式", 
                      "🐧安装QQ", 
                      "🐧修复QQ快捷\n方式", 
                      "💹安装钉钉", 
                      "🛍️安装星火应用商店\n终端版", 
                      "⌨安装fcitx云拼音\n模块", 
                      "🎓安装CAJ Viewer 1.2", 
                      "🔌安装conky\n（桌面插件）", 
                      "启动tmoe工具箱", 
                      "⌨️安装华宇拼音\n输入法"]
        },
        2: {
            'commands': ["echo 命令A", 
                         "echo 命令B", 
                         "echo a",
                         "echo 命令C", 
                         "echo 命令D", 
                         "echo 命令E"],
            'texts': ["💻修改桌面分辨率\n（仅ZeroRootfs）", 
                      "💻修改桌面分辨率\n（仅VNC连接）", 
                      "🗔修改显示DPI\n（支持所有连接，及时生效）", 
                      "❌清理安装过程\n的错误", 
                      "🔙重置xfce\n桌面设置"]
        },
        3: {
            'commands': ["echo 命令A"],
            'texts': ["🔄更新\n本工具"]
        },
        4: {
            'commands': ["echo 命令A", 
                         "echo 命令B", 
                         "echo a",
                         "echo 命令C", 
                         "echo 命令D", 
                         "echo 命令E"],
            'texts': ["画面问题", 
                      "声音问题", 
                      "容器内\n软件问题", 
                      "TermuxX11\n教程", 
                      "共享\n文件夹"]
        },
        5: {
            'commands': ["echo 命令A", 
                         "echo 命令B", 
                         "echo a",
                         "echo 命令C"],
            'texts': ["📁恢复包", 
                      "🤖Android\n软件", 
                      "🐧Linux软件", 
                      "ZR相关\n内容"]
        },
        # 可以继续为其他子菜单添加命令和文本
    }

    # 获取当前子菜单的命令和文本
    data = sub_part_data.get(part_number, {
        'commands': ["echo 默认命令"] * 25,
        'texts': [f"默认按钮 {i+1}" for i in range(25)]
    })

    commands = data['commands']
    part_texts = data['texts']
    
    # 创建子窗口并调用 create_sub_window_parts 函数
    sub_menu = tk.Toplevel()
    sub_menu.title(f"子菜单 {part_number}")
    
    # 传递按钮文本列表和命令列表到 create_sub_window_parts 函数
    create_sub_window_parts(sub_menu, part_texts, commands)




# 创建主窗口
root = tk.Tk()
root.title("主菜单")

# 创建一级菜单
menubar = Menu(root)
root.config(menu=menubar)

# 设置窗口的大小
window_width = 1280
window_height = 800
root.geometry(f"{window_width}x{window_height}")

# 创建一个支持自定义字体的样式
custom_font = font.Font(family="WenQuanYi Zen Hei",size=30, weight="bold")
second_font = font.Font(family="WenQuanYi Zen Hei",size=24, weight="bold")

# 定义每个部分的颜色和文本内容
colors = [
    "#90EE90",  # 亮绿色
    "#3CB371",  # 森林绿
    "#2E8B57",  # 海军蓝
    "#FFD700",  # 金色
    "#FF8C00",  # 暗橙色
    "#FF6347",  # 番茄色
]
part_texts = [
    "1.📦软件安装\n与修复",
    "2.🛠️系统功能",
    "3.🔄更新本工具",
    "4.📃常见问题",
    "5.🔗恢复包等\n资源链接",
    "内容 F",
]

# 创建六个部分的按钮
for i, text in enumerate(part_texts, start=1):
    color = colors[i-1]
    # 直接调用 on_button_click(i) 并传递 part_number
    button = tk.Button(root, text=text, bg=color, fg="white", font=custom_font, 
                       command=lambda i=i: on_button_click(i))
    button.place(relx=(i % 3) * (1 / 3), rely=(i // 3) * (1 / 2), 
                relwidth=(1 / 3), relheight=(1 / 2))

# 创建二级菜单 "文件"
filemenu = Menu(menubar, tearoff=0)
filemenu.add_command(label="打开", command=open_file_dialog)
filemenu.add_command(label="保存", command=open_save_dialog)
filemenu.add_separator()
filemenu.add_command(label="退出", command=root.quit)
menubar.add_cascade(label="文件", menu=filemenu)

# 创建二级菜单 "编辑"
editmenu = Menu(menubar, tearoff=0)
menubar.add_cascade(label="编辑", menu=editmenu)

# 创建三级菜单 "工具 -> 命令"
toolsmenu = Menu(menubar, tearoff=0)
commandmenu = Menu(toolsmenu, tearoff=0)
commandmenu.add_command(label="执行命令: ls", command=lambda: execute_command("ls"))
commandmenu.add_command(label="执行命令: pwd", command=lambda: execute_command("pwd"))
toolsmenu.add_cascade(label="命令", menu=commandmenu)
menubar.add_cascade(label="工具", menu=toolsmenu)

# 关于对话框
menubar.add_command(label="关于", command=about)


# 运行主循环
root.mainloop()