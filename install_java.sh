USER_HOME="/home/tafhim"
# Installing java if the file is ready
if [ ! -f $PWD/jdk-*-linux-x64.tar.gz ]; then
	echo "Java installation files not present, skipping Java and Nebeans" 
else
	tar -xvf jdk-*-linux-x64.tar.gz
	mkdir -p /usr/lib/jvm
	mv jdk1.8* /usr/lib/jvm/jdk1.8.0
	update-alternatives --install "/usr/bin/java" "java" "/usr/lib/jvm/jdk1.8.0/bin/java" 1
	update-alternatives --install "/usr/bin/javac" "javac" "/usr/lib/jvm/jdk1.8.0/bin/javac" 1
	update-alternatives --install "/usr/bin/javaws" "javaws" "/usr/lib/jvm/jdk1.8.0/bin/javaws" 1
	chmod a+x /usr/bin/java
	chmod a+x /usr/bin/javac
	chmod a+x /usr/bin/javaws
	chown -R root:root /usr/lib/jvm/jdk1.8.0
	update-alternatives --config java
	update-alternatives --config javac
	update-alternatives --config javaws
	
	if [ ! -d $USER_HOME/.mozilla/plugins ]; then	
		mkdir $USER_HOME/.mozilla/plugins
	fi
	if [ -d $USER_HOME/.mozilla/plugins ]; then
		ln -s /usr/lib/jvm/jdk1.8.0/jre/lib/amd64/libnpjp2.so $USER_HOME/.mozilla/plugins/
	fi
	if [ -d /usr/lib/chromium-browser/plugins ]; then
		ln -s /usr/lib/jvm/jdk1.8.0/jre/lib/amd64/libnpjp2.so /usr/lib/chromium-browser/plugins/
	fi
	sed -i -e 's/java-\*-sun-1.\*/jdk\*/g' /etc/apparmor.d/abstractions/ubuntu-browsers.d/java
	/etc/init.d/apparmor restart

	#chmod +x netbeans-*-linux.sh
	#./netbeans-*-linux.sh
	rm -rf jdk1.8.0
fi


