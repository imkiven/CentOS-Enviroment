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
##安装和配置apache 服务器
yum install httpd -y  #安装
systemctl start httpd.service  #启动apache
systemctl enable httpd.service  #设置apache开机启动
echo "ServerSignature On  #添加，在错误页中显示Apache的版本，Off为不显示" >> /etc/httpd/conf/httpd.conf
echo "MaxKeepAliveRequests 500  #添加MaxKeepAliveRequests 500 （增加同时连接数）" >> /etc/httpd/conf/httpd.conf
sed -i 's/Options Indexes FollowSymLinks/Options Includes ExecCGI FollowSymLinks/g' /etc/httpd/conf/httpd.conf
sed -i 's/#AddHandler cgi-script .cgi/AddHandler cgi-script .cgi/g' /etc/httpd/conf/httpd.conf
sed -i 's/AllowOverride None/AllowOverride All/g' /etc/httpd/conf/httpd.conf
sed -i 's/#Options Indexes FollowSymLinks/Options FollowSymLinks/g' /etc/httpd/conf/httpd.conf
sed -i 's/DirectoryIndex index.html/DirectoryIndex index.html index.htm Default.html Default.htm index.php/g' /etc/httpd/conf/httpd.conf
sed -i 's/Options Indexes FollowSymLinks/Options Includes ExecCGI FollowSymLinks/g' /etc/httpd/conf/httpd.conf
##安装和配置 mysql
yum install mariadb-server -y # 安装mysql
yum install mariadb-server -y # 安装mysql
systemctl enable mariadb.service #设置 mysql 开机启动
systemctl start mariadb.service #启动 mysql
cp /usr/share/mysql/my-huge.cnf /etc/my.cnf  -y #拷贝配置文件
##安装和配置 php
yum install php -y #安装 php
yum install php-mysql php-gd libjpeg* php-ldap php-odbc php-pear php-xml php-xmlrpc php-mbstring php-bcmath php-mhash -y #安装PHP组件，使PHP支持 MariaDB
# sed -i 's/#date.timezone = PRC/date.timezone = PRC/g' /etc/php.ini
systemctl restart mariadb.service #重启MariaDB
systemctl restart httpd.service #重启apache
##安装java环境
yum -y install java-1.7.0-openjdk*
##安装nginx 服务器
yum install nginx -y
## 安装 tomcat
cd /usr/local
wget http://apache.fayea.com/tomcat/tomcat-8/v8.0.33/bin/apache-tomcat-8.0.33.tar.gz
tar -zxv -f apache-tomcat-8.0.33.tar.gz
rm -rf apache-tomcat-8.0.33.tar.gz
mv apache-tomcat-8.0.33 tomcat
## tomcat 自启动
sed -i '1i\#processname: tomcat' /usr/local/tomcat/bin/startup.sh
sed -i '1i\#description:tomcat auto start' /usr/local/tomcat/bin/startup.sh
sed -i '1i\#chkconfig: 2345 80 90' /usr/local/tomcat/bin/startup.sh
sed -i '/export/a\export CATALINA_BASE=/usr/local/tomcat' /usr/local/tomcat/bin/startup.sh
sed -i '/export/a\export CATALINA_HOME=/usr/local/tomcat' /usr/local/tomcat/bin/startup.sh
sed -i '/export/a\export CATALINA_TMPDIR=/usr/local/tomcat' /usr/local/tomcat/bin/startup.sh
ln -s /usr/local/tomcat/bin/startup.sh /etc/rc.d/init.d/tomcat
cd /etc/rc.d/init.d/
chmod +x tomcat
chkconfig --add tomcat
##执行完后，手动执行下列命令
#修改mysql密码
#mysql_secure_installation
#赋权限
#mysql -uroot -proot123
#grant all privileges on *.* to 'root'@'%' identified by 'root123' with grant option;
