#!/bin/bash

#
# Ensure we only run as root.
#
if [ "$(whoami)" != "root" ]; then
	echo "You may only run this script as root."
	echo "Usage:"
	echo -e "\tsudo ./install.sh 256 512"
	echo ""
	exit 1
fi

if [ $# -lt 2 ]; then
	echo "You must provide 2 arguments: min heap memory and max heap memory."
	echo ""
	exit 1
fi


#
# Download and setup JDK 7 (1.7.0)
#
wget http://download.oracle.com/otn-pub/java/jdk/7/jdk-7-linux-x64.tar.gz
tar xcvf ./jdk-7-linux-x64.tar.gz

mkdir -p /usr/lib/jvm/jdk1.7.0
mv ./jdk1.7.0/* /usr/lib/jvm/jdk1.7.0/
rm -f ./jdk1.7.0

exit 1

#
# Tell Debian about this new Java
#
update-alternatives --install "/usr/bin/java" "java" "/usr/lib/jvm/jdk1.7.0/bin/java" 1
update-alternatives --install "/usr/bin/javac" "javac" "/usr/lib/jvm/jdk1.7.0/bin/javac" 1 
update-alternatives --install "/usr/bin/javaws" "javaws" "/usr/lib/jvm/jdk1.7.0/bin/javaws" 1

update-alternatives --set java /usr/lib/jvm/jdk1.7.0/bin/java
update-alternatives --set javac /usr/lib/jvm/jdk1.7.0/bin/javac


#
# Now, download Tomcat 7.0.30 
#
wget http://apache.petsads.us/tomcat/tomcat-7/v7.0.30/bin/apache-tomcat-7.0.30.tar.gz
tar xcvf ./apache-tomcat-7.0.30.tar.gz

mv ./apache-tomcat-7.0.30 /opt
ln -s /opt/tomcat /opt/apache-tomcat-7.0.30

chmod +x /opt/tomcat/bin/*.sh


#
# Copy the service script over to /etc/init.d. Alter it so
# that it starts up the Java VM with correct options.
#
cp ./tomcat /etc/init.d/
chmod 755 /etc/init.d/tomcat

sed -i 's/-Xms1m/-Xms$1m/g' /etc/init.d/tomcat
sed -i 's/-Xmx1m/-Xmx$2m/g' /etc/init.d/tomcat


#
# Make sure Tomcat runs on startup
#
update-rc.d tomcat defaults
