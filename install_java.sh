# Unix user
if [ "$1" = "" ]; then
  echo "You have to specify a user"
  exit
fi
USER=$1
USER_HOME="/home/$USER"
if [ ! -d $USER_HOME ]; then
  echo "The user's home directory could not be located"
  exit
fi

tar_location=$2
if [ "$2" = "" ]; then
  echo "Tar location not specified, looking into $PWD"
  tar_location=$PWD
fi

# Installing java if the file is ready
for jdkf in $(ls $tar_location | grep jdk); do
  echo "Java installation tar found in $tar_location/$jdkf, extracting..."
  tar tzf $tar_location/$jdkf | sed -e 's@/.*@@' | uniq | read jdkdir;
  tar -xf $tar_location/$jdkf -C $tar_location

  echo "Extraction complete, moving to /usr/bin/jvm/$jdkdir"
  mkdir -p /usr/lib/jvm
  mv $tar_location/$jdkdir /usr/lib/jvm/$jdkdir
  update-alternatives --install "/usr/bin/java" "java" "/usr/lib/jvm/$jdkdir/bin/java" 1
  update-alternatives --install "/usr/bin/javac" "javac" "/usr/lib/jvm/$jdkdir/bin/javac" 1
  update-alternatives --install "/usr/bin/javaws" "javaws" "/usr/lib/jvm/$jdkdir/bin/javaws" 1
  chmod a+x /usr/bin/java
  chmod a+x /usr/bin/javac
  chmod a+x /usr/bin/javaws
  chown -R root:root /usr/lib/jvm/$jdkdir
  update-alternatives --config java
  update-alternatives --config javac
  update-alternatives --config javaws

  if [ ! -d $USER_HOME/.mozilla/plugins ]; then	
    mkdir $USER_HOME/.mozilla/plugins
  fi

  if [ -d $USER_HOME/.mozilla/plugins ]; then
    # WARNING: 64 bit specific
    echo "Setting up mozilla plugin for java"
    ln -s /usr/lib/jvm/$jdkdir/jre/lib/amd64/libnpjp2.so $USER_HOME/.mozilla/plugins/
  fi

  if [ -d /usr/lib/chromium-browser/plugins ]; then
    # WARNING: 64 bit specific
    echo "Setting up chromium plugin for java"
    ln -s /usr/lib/jvm/$jdkdir/jre/lib/amd64/libnpjp2.so /usr/lib/chromium-browser/plugins/
  fi
  sed -i -e 's/java-\*-sun-1.\*/jdk\*/g' /etc/apparmor.d/abstractions/ubuntu-browsers.d/java
  /etc/init.d/apparmor restart

  rm -rf $tar_location/$jdkdir 

  echo "Java installation completed"
done
