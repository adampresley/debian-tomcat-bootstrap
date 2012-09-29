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
# JDK 7 (1.7.0). I haven't figured out how to download this
# automagically, cause you have to accept user agreement.
# So this will check the current directory for the tar file.
#
if [ -d "/usr/lib/jvm/jdk1.7.0/" ]; then
	rm -f -r /usr/lib/jvm/jdk1.7.0/
fi

if [ ! -f "jdk-7-linux-x64.tar.gz" ]; then
	echo "You must first download and place the JDK 1.7.0 tar file in this directory."
	exit 1
fi

tar xvzf ./jdk-7-linux-x64.tar.gz

mkdir -p /usr/lib/jvm/jdk1.7.0
mv ./jdk1.7.0/* /usr/lib/jvm/jdk1.7.0/
rm -f -r ./jdk1.7.0/


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
if [ -f "apache-tomcat-7.0.30.tar.gz" ]; then
	rm ./apache-tomcat-7.0.30.tar.gz
fi

wget http://apache.petsads.us/tomcat/tomcat-7/v7.0.30/bin/apache-tomcat-7.0.30.tar.gz
tar xvzf ./apache-tomcat-7.0.30.tar.gz

if [ -d "/opt/apache-tomcat-7.0.30/" ]; then
	rm -f -r /opt/apache-tomcat-7.0.30/
fi

if [ -h "/opt/tomcat" ]; then
	rm /opt/tomcat
fi

mv ./apache-tomcat-7.0.30 /opt
ln -s /opt/apache-tomcat-7.0.30/ /opt/tomcat

chmod +x /opt/tomcat/bin/*.sh

rm -f -r ./apache-tomcat-7.0.30/


#
# Copy the service script over to /etc/init.d. Alter it so
# that it starts up the Java VM with correct options.
#
cp ./tomcat /etc/init.d/
chmod 755 /etc/init.d/tomcat

sed -i "s/-Xms1m/-Xms$1m/g" /etc/init.d/tomcat
sed -i "s/-Xmx1m/-Xmx$2m/g" /etc/init.d/tomcat


#
# Make sure Tomcat runs on startup
#
update-rc.d tomcat defaults
