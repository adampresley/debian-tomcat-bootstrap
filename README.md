# Debian Tomcat Bootstraper

This repository is comprised of a set of bootstrap scripts for 
setting up and configuring a stock Tomcat on a Debian server.
This will setup JDK 7 as the default Java installation, download
Tomcat into the */opt* directory, and install an **init.d** service
script.

To use this follow these steps:

```bash
$ cd ~
$ apt-get install git
$ git clone git://github.com/adampresley/debian-tomcat-bootstrap.git
$ cd debian-tomcat-bootstrap
$ ./install.sh 256 512
```

Note that there are two arguments for the install script. These are 
the minimum and maximum heap size to use for the JVM. Set these to 
whatever your needs are.