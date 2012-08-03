#!/bin/sh

date
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/vmware/bin:/opt/vmware/bin:/root/bin:$PATH

cb_package_url="http://packages.couchbase.com/releases/1.8.1/couchbase-server-enterprise_x86_64_1.8.1.rpm"
cb_package="couchbase-server-enterprise_x86_64_1.8.1.rpm"
if [ "${ssh_password}" = "" ]
then
	password="couchbase123"
else
	password="${ssh_password}"
fi
arch=".x86_64"
user="cb"


echo "Checking for packages"
rpm -qa|grep -i curl
if [ $? -ne 0 ] 
then
    echo "Package curl not installed - installing...."
    yum -y install curl${arch}
    if [ $? -ne 0 ] 
    then
        echo "Package curl not installed and install of curl${arch} failed"
        exit 1
    fi  
fi

rpm -qa|grep -i openssl
if [ $? -ne 0 ] 
then
    echo "Package openssql not installed - installing...."
    yum -y install openssl${arch}
    if [ $? -ne 0 ] 
    then
        echo "Package openssl not installed and install of openssl${arch} failed"
        exit 1
    fi  
fi

rpm -qa|grep -i shadow-utils
if [ $? -ne 0 ] 
then
    echo "Package shadow-utils not installed - installing...."
    yum -y install shadow-utils${arch}
    if [ $? -ne 0 ] 
    then
        echo "Package shadow-utils not installed and install of shadow-utils${arch} failed"
        exit 1
    fi  
fi


yum -y install bc${arch}
if [$? -ne 0 ]
then
	echo "Package bc install failed"
	exit 1
fi

echo "Downloading Couchbase package..."
curl -On ${cb_package_url}
if [ $? -ne 0 ] 
then
    echo "Error downloading: ${cb_package_url}"
    exit 1
fi

rpm -Uvh ${cb_package}
if [ $? -ne 0 ] 
then
    echo "RPM install of ${cb_package} failed"
    exit 1
fi

echo "Setting up password hash with openssl..."
user_pass="`openssl passwd -crypt ${password}`"
if [ $? -ne 0 ] 
then
    echo "Password hashing for ${user} with openssl failed"
    exit 1
fi

echo "Creating User with..."
useradd ${user} --password ${user_pass}
if [ $? -ne 0 ]
then 
    echo "Could not add user ${user}"
    exit 1
fi

echo "Adding User to sudoers..."
echo "${user}  ALL=(ALL) ALL" >> /etc/sudoers
if [ $? -ne 0 ] 
then
    echo "Could not add user ${user} to sudoers list"
    exit 1
fi

date
