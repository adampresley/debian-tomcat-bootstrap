# Debian Tomcat Bootstraper

This repository is comprised of a set of bootstrap scripts for 
setting up and configuring a stock Tomcat on a Debian server.
This will setup JDK 7 as the default Java installation, download
Tomcat into the */opt* directory, and install an **init.d** service
script.

Before you do anything, however, you'll need to download the 
Oracle JDK 1.7.0 tar file and copy this to the debian-tomcat-boostrap
directory created during the clone process.

To use this follow these steps:

```bash
$ cd ~
$ apt-get install git
$ git clone git://github.com/adampresley/debian-tomcat-bootstrap.git
$
$ cd debian-tomcat-bootstrap
$ chmod +x ./install.sh
$ ./install.sh 256 512
```

Note that there are two arguments for the install script. These are 
the minimum and maximum heap size to use for the JVM. Set these to 
whatever your needs are.