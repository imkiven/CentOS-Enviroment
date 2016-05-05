##更新
yum update
##安装和配置apache 服务器
yum install httpd -y  #安装
systemctl start httpd.service  #启动apache
systemctl enable httpd.service  #设置apache开机启动
echo "ServerSignature On  #添加，在错误页中显示Apache的版本，Off为不显示" >> /etc/httpd/conf/httpd.conf 



##安装和配置 mysql
yum install mariadb-server -y # 安装mysql
systemctl enable mariadb.service #设置 mysql 开机启动
systemctl start mariadb.service #启动 mysql
cp /usr/share/mysql/my-huge.cnf /etc/my.cnf #拷贝配置文件

 ##安装和配置 php
yum install php -y #安装 php
yum install php-mysql php-gd libjpeg* php-ldap php-odbc php-pear php-xml php-xmlrpc php-mbstring php-bcmath php-mhash -y #安装PHP组件，使PHP支持 MariaDB

systemctl restart mariadb.service #重启MariaDB
systemctl restart httpd.service #重启apache
