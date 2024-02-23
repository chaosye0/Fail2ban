clear
#CheckIfRoot
[ $(id -u) != "0" ] && { echo "${CFAILURE}Error: You must be root to run this script${CEND}"; exit 1; }


#ReadSSHPort
[ -z "`grep ^Port /etc/ssh/sshd_config`" ] && ssh_port=22 || ssh_port=`grep ^Port /etc/ssh/sshd_config | awk '{print $2}'`

apt-get -y update
apt-get -y install lsb-release

#Read Imformation From The User
echo "Welcome to Fail2ban!"
echo "--------------------"
echo "This Shell Script only support ubuntu 20.04!!!"
echo ""

while :; do echo
  read -p "Is your SSH Port = 22? [y/n]: " IfChangeSSHPort
  if [ ${IfChangeSSHPort} == 'n' ]; then
    if [ -e "/etc/ssh/sshd_config" ];then
    while :; do echo
        read -p "Please input SSH port(Default: $ssh_port): " SSH_PORT
        [ -z "$SSH_PORT" ] && SSH_PORT=$ssh_port
        if [ $SSH_PORT -eq 22 >/dev/null 2>&1 -o $SSH_PORT -gt 1024 >/dev/null 2>&1 -a $SSH_PORT -lt 65535 >/dev/null 2>&1 ];then
            break
        else
            echo "${CWARNING}input error! Input range: 22,1025~65534${CEND}"
        fi
    done
    fi
    break
  elif [ ${IfChangeSSHPort} == 'y' ]; then
    break
  else
    echo "${CWARNING}Input error! Please only input y or n!${CEND}"
  fi
done
ssh_port=$SSH_PORT
echo $ssh_port
echo ""
echo ""
	read -p "Input the maximun times for trying [2-10]:  " maxretry
echo ""
read -p "Input the lasting time for blocking a IP [hours]:  " bantime
if [ ${maxretry} == '' ]; then
	maxretry=3
fi
if [ ${bantime} == '' ];then
	bantime=24
fi
((bantime=$bantime*60*60))

#Install


apt-get -y update
apt-get -y install fail2ban
apt-get -y install ufw

ufw allow 22
ufw allow $ssh_port
ufw allow 80
ufw allow 443

systemctl start ufw
systemctl enable ufw
ufw enable

#Configure
rm -rf /etc/fail2ban/jail.local
touch /etc/fail2ban/jail.local

cat <<EOF >> /etc/fail2ban/jail.local
[DEFAULT]
ignoreip = 127.0.0.1
bantime = 86400
maxretry = $maxretry
findtime = 1800

[ssh-ufw]
enabled = true
banaction = ufw
banaction_allports = ufw
logpath = /var/log/auth.log
maxretry = $maxretry
findtime = 3600
bantime = $bantime
EOF


#Start
    systemctl restart fail2ban
    systemctl enable fail2ban

#Finish
echo "Finish Installing ! Reboot the sshd now !"

    systemctl restart sshd


echo ""

echo "Fail2ban is now runing on this server now!"
