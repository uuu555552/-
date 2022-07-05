yum install wget
echo y|yum install git
#这里需要y

sudo yum install gcc
echo y|yum install xdg-utils

yum -y install nmap
echo y|yum install git gcc make libpcap-devel

git clone https://github.com/robertdavidgraham/masscan
cd masscan
make install

#启动防火墙

systemctl start firewalld

firewall-cmd --zone=public --add-port=5672/tcp --permanent
firewall-cmd --zone=public --add-port=15672/tcp –permanent
firewall-cmd --zone=public --add-port=3306/tcp –permanent
firewall-cmd --zone=public --add-port=8080/tcp –permanent
firewall-cmd --reload
cd /opt
#安装go
wget https://dl.google.com/go/go1.16.13.linux-amd64.tar.gz
tar -C /usr/local/ -xzf go1.16.13.linux-amd64.tar.gz
#安装nodejs
wget https://nodejs.org/download/release/v12.16.1/node-v12.16.1-linux-x64.tar.xz
tar -xf node-v12.16.1-linux-x64.tar.xz
mv node-v12.16.1-linux-x64 /usr/local/node
#安装数据库
wget \
https://cdn.mysql.com/archives/mysql-5.7/mysql-community-client-5.7.32-1.el7.x86_64.rpm \
https://cdn.mysql.com/archives/mysql-5.7/mysql-community-common-5.7.32-1.el7.x86_64.rpm \
https://cdn.mysql.com/archives/mysql-5.7/mysql-community-libs-5.7.32-1.el7.x86_64.rpm \
https://cdn.mysql.com/archives/mysql-5.7/mysql-community-libs-compat-5.7.32-1.el7.x86_64.rpm \
https://cdn.mysql.com/archives/mysql-5.7/mysql-community-server-5.7.32-1.el7.x86_64.rpm
yum install -y mysql-community-*-5.7.32-1.el7.x86_64.rpm
#安装rabbitmq
wget \
http://repo.iotti.biz/CentOS/7/x86_64/socat-1.7.3.2-5.el7.lux.x86_64.rpm \
https://github.com/rabbitmq/erlang-rpm/releases/download/v20.3.4/erlang-20.3.4-1.el7.centos.x86_64.rpm \
https://github.com/rabbitmq/rabbitmq-server/releases/download/v3.7.14/rabbitmq-server-3.7.14-1.el7.noarch.rpm 

rpm -ivh socat-1.7.3.2-5.el7.lux.x86_64.rpm
rpm -ivh erlang-20.3.4-1.el7.centos.x86_64.rpm
rpm -ivh rabbitmq-server-3.7.14-1.el7.noarch.rpm


mkdir go
cd go
mkdir src
mkdir pkg
mkdir bin
#配置go环境和nodejs环境变量
echo 'export NODEJS=/usr/local/node' >>/etc/profile
echo 'export PATH=$NODEJS/bin:$PATH' >>/etc/profile

echo 'export GOROOT=/usr/local/go' >>/etc/profile
echo 'export GOPATH=/opt/go' >>/etc/profile
echo 'export PATH=$PATH:$GOROOT/bin:$GOPATH' >>/etc/profile
echo 'export GO111MODULE="on"' >>/etc/profile
echo 'export GOPROXY=https://goproxy.cn,direct' >>/etc/profile

#重新启动配置文件
source /etc/profile
#启动rabbitmq-server
service rabbitmq-server start
#开机自动启动
chkconfig rabbitmq-server on
#下载web
rabbitmq-plugins enable rabbitmq_management
#启动mysql数据库
systemctl start mysqld
#配置设置mysql

#验证是否安装
echo"##################验证是否安装成功################3"
go version
mysql -V
node -v
npm -v

line=$(cat /var/log/mysqld.log | grep password | grep "temporary" | sed -n '1p')
echo $line
linn=$(echo ${line#*: })
echo $linn
