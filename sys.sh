#！ /bin/bash
##更新
yum update -y
##关闭firewall：
systemctl stop firewalld.service #停止firewall
systemctl disable firewalld.service #禁止firewall开机启动
##安装iptables防火墙
yum install iptables-services -y #安装
#编辑防火墙配置文件
echo '# Firewall configuration written by system-config-firewall
      # Manual customization of this file is not recommended.
      *filter
      :INPUT ACCEPT [0:0]
      :FORWARD ACCEPT [0:0]
      :OUTPUT ACCEPT [0:0]
      -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
      -A INPUT -p icmp -j ACCEPT
      -A INPUT -i lo -j ACCEPT
      -A INPUT -m state --state NEW -m tcp -p tcp --dport 22 -j ACCEPT
      -A INPUT -m state --state NEW -m tcp -p tcp --dport 80 -j ACCEPT
      -A INPUT -m state --state NEW -m tcp -p tcp --dport 3306 -j ACCEPT
      -A INPUT -j REJECT --reject-with icmp-host-prohibited
      -A FORWARD -j REJECT --reject-with icmp-host-prohibited
      COMMIT' > /etc/sysconfig/iptables
#安装lrzs
yum install lrzsz -y
