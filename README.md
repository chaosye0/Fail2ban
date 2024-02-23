# Fail2ban #
这是一个利用fail2ban和ufw来进行服务器简单防爆破的脚本。默认自带SSH防御规则。

在原版基础上改用了ufw，只适用于ubuntu 20.04!!!!

# 功能 #
- 自助修改SSH端口
- 自定义最高封禁IP的时间（以小时为单位）
- 自定义SSH尝试连接次数
- 一键完成SSH防止暴力破解

# 支持系统 #
- Ubuntu 20.04 (x86/x64)


# 安装 #
    wget https://raw.githubusercontent.com/chaosye0/Fail2ban/master/fail2ban.sh && bash fail2ban.sh 2>&1 | tee fail2ban.log
1. 第一步选择是否修改SSH端口。
1. 第二部输入最多尝试输入SSH连接密码的次数
1. 第三部输入每个恶意IP的封禁时间（单位：小时）

# 卸载 #
    wget https://raw.githubusercontent.com/chaosye0/Fail2ban/master/uninstall.sh && bash uninstall.sh
